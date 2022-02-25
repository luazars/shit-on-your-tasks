import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_register/screens/add_task_screen.dart';
import 'package:login_register/shared/bg_widget.dart';
import '../models/single_entry_material.dart';
import '../models/task_model.dart';
import '../services/firebase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  setStateOnHomescreen() => setState(() {});

  List<Task> tasks = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //Firebase.getChangeOnFirebase(setStateOnHomescreen);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      Scaffold(
        appBar: AppBar(
          title: Text("Welcome back"),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {
                  //Firebase.logout(context);
                }),
          ],
        ),
        body: ReorderableListView.builder(
          onReorder: ((oldIndex, newIndex) =>
              Task.reorder(tasks, oldIndex, newIndex)),
          itemCount: tasks.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey(tasks[index].title +
                  tasks.length.toString() +
                  index.toString()),
              onDismissed: (value) {
                setState(() {
                  tasks.removeAt(index);
                  print(Timestamp.now());
                });
              },
              background: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.delete_rounded,
                    ),
                  ],
                ),
              ),
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) =>
                      AddTaskScreen(setStateOnHomescreen, tasks))));
            });
          }),
          child: const Icon(
            Icons.add_rounded,
          ),
        ),
      ),
    );
  }
}
