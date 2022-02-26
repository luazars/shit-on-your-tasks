import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_register/screens/add_task_screen.dart';
import 'package:login_register/shared/bg_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/single_entry_material.dart';
import '../models/task_model.dart';
import '../services/firebase.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
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
    getDataFirebase();
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
          child: Column(
            children: [
              const SizedBox(height: 10),
              SingleEntry(
                tasks[index],
                setStateOnHomescreen,
              ),
            ],
          ),
        );
      },
    );

    final addTasks = FloatingActionButton(
        onPressed: (() => setState(() => Navigator.of(context).push(
            MaterialPageRoute(
                builder: ((context) =>
                    AddTaskScreen(setStateOnHomescreen, tasks)))))),
        child: const Icon(Icons.add_rounded));

    return Background(
      Scaffold(
          appBar: AppBar(
            title: const Text("Welcome back"),
            actions: [
              IconButton(
                  icon: const Icon(Icons.get_app_rounded),
                  onPressed: () => getPref()),
              IconButton(
                  icon: const Icon(Icons.sync_rounded),
                  onPressed: () => savePref()),
              IconButton(
                  icon: const Icon(Icons.logout_rounded),
                  onPressed: () {
                    //Firebase.logout(context);
                  }),
            ],
          ),

          //*List with Tasktiles
          body: reorderableTaskList,
          floatingActionButton: addTasks),
    );
  }

  //*Firebase Methods
  Future<void> syncFirebase() async {
    await Firebase.clearTasksOnFirebase();
    for (var i = 0; i < tasks.length; i++) {
      Firebase.pushToFirebase(tasks[i]);
    }
  }

  Future<void> getDataFirebase() async {
    tasks = (await Firebase.pullFromFirebase())!;
    tasks.sort((a, b) => a.index.compareTo(b.index));
    setState(() {});
  }

  //*SharedPreferences Methods
  savePref() async {
    final prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < tasks.length; i++) {
      prefs.setString("task $i", jsonEncode(tasks[i]));
    }
    Fluttertoast.showToast(msg: "send");
  }

  getPref() async {
    final prefs = await SharedPreferences.getInstance();
    int a = 0;
    Task? task;
    do {
      task = jsonDecode(prefs.getString("task$a") ?? "");
      tasks.add(task!);
      a++;
    } while (task != null);
    Fluttertoast.showToast(msg: "da");
  }
}
