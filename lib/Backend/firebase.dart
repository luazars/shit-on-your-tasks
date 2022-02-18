import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Material/user_material.dart';
import '../screens/login_screen.dart';

class Firebase {
  static UserModel loggedInUser = UserModel();
  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  static Future<void> getChangeOnFireBase(Function setState) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => loggedInUser = UserModel.fromMap(value.data()));
    setState();
  }

  static void postNewTaskToFirebase(String task) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    List? testTasks = loggedInUser.tasks;
    testTasks?.add(task);

    loggedInUser.tasks = testTasks;

    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(loggedInUser.toMap())
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
    Fluttertoast.showToast(msg: "Added succes");
  }

  static UserModel getUser() {
    return loggedInUser;
  }
}
