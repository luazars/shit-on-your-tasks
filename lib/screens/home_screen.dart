import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import "package:login_register/screens/add_task_screen.dart";
import 'package:login_register/screens/detail_screen.dart';
import 'package:login_register/shared/bg_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/single_entry_material.dart';
import '../models/task_model.dart';
import '../services/firebase.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final bool fromLoginScreen;
  const HomeScreen(this.fromLoginScreen, {Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //*Set state Function for other classes
  setStateOnHomescreen() => setState(() {});

  //*List with Tasks
  List<Task> tasks = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    widget.fromLoginScreen ? getDataFirebase() : getPref();
  }

  @override
  Widget build(BuildContext context) {
    //*Widgets

    final reorderableTaskList = ReorderableListView.builder(
      onReorder: ((oldIndex, newIndex) =>
          Task.reorderTaskList(tasks, oldIndex, newIndex)),
      itemCount: tasks.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) {
        //* Dismissible Tasktile
        return Dismissible(
          key: ValueKey(
              tasks[index].title + tasks.length.toString() + index.toString()),
          onDismissed: (value) => setState(() => tasks.removeAt(index)),
          direction: DismissDirection.startToEnd,
          //*BG of Dismissible
          background: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.delete_rounded),
              ],
            ),
          ),

          //*Tasktile
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => AddTaskScreen(
                      setStateOnHomescreen,
                      tasks,
                      isEdit: true,
                      taskToEdit: tasks[index],
                    )))),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SingleEntry(
                  tasks[index],
                  setStateOnHomescreen,
                ),
              ],
            ),
          ),
        );
      },
    );

    return Background(
      Scaffold(
          appBar: AppBar(
            title: const Text("Welcome back"),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                  icon: const Icon(Icons.sync_rounded),
                  onPressed: () {
                    syncFirebase();
                    savePref();
                  }),
              IconButton(
                  icon: const Icon(Icons.login_rounded),
                  onPressed: () {
                    logout(context);
                  }),
            ],
          ),

          //*List with Tasktiles
          body: reorderableTaskList,
          floatingActionButton: FloatingActionButton(
              onPressed: (() {
                setState(() {});
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) =>
                        AddTaskScreen(setStateOnHomescreen, tasks))));
              }),
              child: const Icon(Icons.add_rounded))),
    );
  }

  void logout(BuildContext context) async {
    if (!await sync()) {
      clearPref();
      Firebase.logout(context);
    } else {
      Fluttertoast.showToast(msg: "Try again with internet");
    }
  }

  //*Firebase Methods
  Future<bool> syncFirebase() async {
    await Firebase.clearTasksOnFirebase();
    for (var i = 0; i < tasks.length; i++) {
      if (!await Firebase.pushToFirebase(tasks[i])) {
        return false;
      }
    }
    return true;
  }

  Future<void> getDataFirebase() async {
    tasks = (await Firebase.pullFromFirebase())!;
    tasks.sort((a, b) => a.index.compareTo(b.index));
    setState(() {});
  }

  //*SharedPreferences Methods
  savePref() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listString = List.empty(growable: true);
    for (var i = 0; i < tasks.length; i++) {
      listString.add(jsonEncode(Task.taskToMap(tasks[i])));
    }
    prefs.setStringList("tasks", listString);
  }

  getPref() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listString = prefs.getStringList("tasks") ?? [];
    tasks.clear();
    for (var i = 0; i < listString.length; i++) {
      tasks.add(Task.mapToTask(jsonDecode(listString[i])));
    }
    setState(() {});
  }

  void clearPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("tasks", []);
  }

  Future<bool> sync() async {
    savePref();
    if (!await syncFirebase()) {
      return false;
    }
    return true;
  }
}
