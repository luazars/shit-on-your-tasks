import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_register/Backend/firebase.dart';

import 'home_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final Function setStateMain;
  const AddTaskScreen(this.setStateMain, {Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController taskTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add you task")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: taskTextController,
            onSubmitted: (value) {
              taskTextController.text = value;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              addTask(taskTextController.text);
            },
            child: const Text(
              "Add Task",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  addTask(String task) {
    Firebase.postNewTaskToFirebase(task);
    Fluttertoast.showToast(msg: task);
    Navigator.pop(context);
    widget.setStateMain();
  }
}
