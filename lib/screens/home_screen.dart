import "package:flutter/material.dart";
import "package:login_register/screens/add_task_screen.dart";
import 'package:login_register/services/shared_preferences.dart';
import 'package:login_register/services/sync.dart';
import '../models/single_entry_material.dart';
import '../models/task_model.dart';
import '../services/firebase.dart';

class HomeScreen extends StatefulWidget {
  final bool fromLoginScreen;
  const HomeScreen(this.fromLoginScreen, {Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //*List with Tasks
  List<Task> tasks = List.empty(growable: true);

  @override
  void initState() {
    if (widget.fromLoginScreen) {
      getData();
      LocalData.savePref(tasks);
    } else {
      LocalData.getPref(tasks);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //*Widgets

    final reorderableTaskList = ReorderableListView.builder(
      onReorder: ((oldIndex, newIndex) {
        Task.reorderTaskList(tasks, oldIndex, newIndex);
        Sync.sync(tasks);
      }),
      itemCount: tasks.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) {
        //* Dismissible Task-tile
        return Dismissible(
          key: ValueKey(
              tasks[index].title + tasks.length.toString() + index.toString()),
          onDismissed: (value) {
            setState(() => tasks.removeAt(index));
            Sync.sync(tasks);
          },
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

          //*Task-tile
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => AddTaskScreen(
                      setStateOnHomeScreen,
                      tasks,
                      isEdit: true,
                      taskToEdit: tasks[index],
                    )))),
            child: Column(
              children: [
                //const SizedBox(height: 10),
                SingleEntry(tasks[index], setStateOnHomeScreen, tasks),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title:
              Text("Welcome back " + (Firebase.loggedInUser.firstName ?? "")),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.login_rounded),
                onPressed: () {
                  Firebase.logout(context, tasks);
                }),
          ],
        ),

        //*List with Task-tiles
        body: tasks.isEmpty
            ? const Center(
                child: Text("Everything done. \nTake a break! \n;)"),
              )
            : reorderableTaskList,
        floatingActionButton: FloatingActionButton(
            onPressed: (() {
              setState(() {});
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) =>
                      AddTaskScreen(setStateOnHomeScreen, tasks))));
            }),
            child: const Icon(Icons.add_rounded)));
  }

  //*Set state Function for other classes
  void setStateOnHomeScreen() {
    setState(() {});
    Sync.sync(tasks);
  }

  getData() async {
    tasks = await Sync.getDataFirebase(tasks);
    setState(() {});
  }
}
