import 'package:flutter/material.dart';
import 'package:login_register/Backend/firebase.dart';

class AlertDialogTasks {
  static Future<void> showTaskDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New Entry"),
          content: SizedBox(
            child: TextField(
              style: TextStyle(
                backgroundColor: Theme.of(context).focusColor,
              ),
              autofocus: true,
              onSubmitted: (value) => Firebase.postNewTaskToFirebase(value),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your To-Do",
              ),
            ),
          ),
        );
      },
    );
  }
}
