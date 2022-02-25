import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_register/models/task_model.dart';
import '../models/user_material.dart';
import '../screens/login_screen.dart';

class Firebase {
  //User stuff in Firebase
  static UserModel _loggedInUser = UserModel();

  static UserModel get loggedInUser {
    return _loggedInUser;
  }

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static Future<void> logout(BuildContext context, FirebaseAuth _auth) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  static registerNewUser(String _firstName, String _secondName,
      FirebaseAuth _auth, FirebaseFirestore _firebaseFirestore) async {
    User? _user = _auth.currentUser;

    UserModel userModel = UserModel();
    userModel.email = _user?.email;
    userModel.uid = _user?.uid;
    userModel.firstName = _firstName;
    userModel.secondName = _secondName;

    await _firebaseFirestore
        .collection("users")
        .doc(_user?.uid)
        .set(userModel.toMap())
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  static Future<void> clearTasksOnFirebase() async {
    var collection = firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  //syncronize
  static void pushFirebase(Task task) async {
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .doc(task.title + task.color.toString())
        .set(Task.taskToMap(task))
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  static Future<List<Task>?> pullFirebase() async {
    List<Task>? tasksData = List.empty(growable: true);
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => _loggedInUser = UserModel.fromMap(value.data()));

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("tasks")
        .get()
        .then((value) {
      for (var item in value.docs) {
        tasksData.add(Task(
          item.data()["title"],
          item.data()["text"],
          item.data()["isDone"],
          Color.fromARGB(250, item.data()["color"][0], item.data()["color"][1],
              item.data()["color"][2]),
          item.data()["index"],
        ));
      }
    });
    return tasksData;
  }
}
