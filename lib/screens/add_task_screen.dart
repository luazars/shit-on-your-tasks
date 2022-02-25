import 'dart:math';
import 'package:flutter/material.dart';
import 'package:login_register/models/colors_material.dart';
import 'package:login_register/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final Function setStateMain;
  final List tasks;
  const AddTaskScreen(this.setStateMain, this.tasks, {Key? key})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskTitleController = TextEditingController();
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
          addTask(taskTitleController.text);
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

    final taskTitleField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: taskTitleController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please enter something");
            }
            return null;
          },
          obscureText: false,
          onSaved: (value) {
            taskTitleController.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Title",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );

    final taskTextField = Column(
      children: [
        TextFormField(
          autofocus: false,
          controller: taskTextController,
          keyboardType: TextInputType.text,
          obscureText: false,
          onSaved: (value) {
            taskTextController.text = value ?? "";
          },
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Notes",
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              taskTitleField,
              taskTextField,
              const SizedBox(height: 20),
              addTaskButton,
            ],
          ),
        ),
      ),
    );
  }

  addTask(String taskTitle) {
    //Firebase.postNewTaskToFirebase(task, widget.firebaseFirestore);
    if (_formKey.currentState!.validate()) {
      widget.tasks.add(Task(
          taskTitle,
          taskTitle,
          false,
          Color.fromARGB(250, Random().nextInt(100) + 150, Random().nextInt(50),
              Random().nextInt(50))));
      Navigator.pop(context);
      widget.setStateMain();
    }
  }
}
