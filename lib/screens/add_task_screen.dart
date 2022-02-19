import 'package:flutter/material.dart';

import '../services/firebase.dart';

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
    final addTaskButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
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
    );

    final taskTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: taskTextController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter your Email");
            }
            if (value.toString().length < 4) {
              return ("Please enter a real Email");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            taskTextController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Your task",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Add you task")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            taskTextField,
            const SizedBox(height: 20),
            addTaskButton,
          ],
        ),
      ),
    );
  }

  addTask(String task) {
    Firebase.postNewTaskToFirebase(task);
    Navigator.pop(context);
    widget.setStateMain();
  }
}
