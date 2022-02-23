import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user_material.dart';
import '../screens/login_screen.dart';

class Firebase {
  //User stuff in Firebase
  static UserModel _loggedInUser = UserModel();

  static UserModel get loggedInUser {
    return _loggedInUser;
  }

  static Future<void> logout(BuildContext context, FirebaseAuth _auth) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  static registerNewUser(String firstName, String secondName,
      FirebaseAuth _auth, FirebaseFirestore firebaseFirestore) async {
    User? user = _auth.currentUser;

    List<String> listString = List.empty();
    List<bool> listBool = List.empty();

    UserModel userModel = UserModel();
    userModel.email = user?.email;
    userModel.uid = user?.uid;
    userModel.firstName = firstName;
    userModel.secondName = secondName;
    userModel.tasks = listString;
    userModel.tasksIsDone = listBool;

    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .set(userModel.toMap())
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  //Task stuff in

  static void postNewTaskToFirebase(
      String task, FirebaseFirestore firebaseFirestore) async {
    List? testTasks = _loggedInUser.tasks;
    List? tasksIsDoneList = _loggedInUser.tasksIsDone;
    testTasks?.add(task);
    tasksIsDoneList?.add(false);
    _loggedInUser.tasks = testTasks;
    _loggedInUser.tasksIsDone = tasksIsDoneList;
    postChangeToFirebase(firebaseFirestore);
  }

  static void removeEntryFromFirestore(
      int index, FirebaseFirestore firebaseFirestore) async {
    List? tasksList = _loggedInUser.tasks;
    List? tasksIsDoneList = _loggedInUser.tasksIsDone;
    tasksList?.removeAt(index);
    tasksIsDoneList?.removeAt(index);
    _loggedInUser.tasks = tasksList;
    _loggedInUser.tasksIsDone = tasksIsDoneList;
    postChangeToFirebase(firebaseFirestore);
  }

  static void reorderTiles(
      int oldIndex, int newIndex, FirebaseFirestore firebaseFirestore) async {
    List? testTasks = _loggedInUser.tasks;
    List? tasksIsDoneList = _loggedInUser.tasksIsDone;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    RangeError.checkValidIndex(oldIndex, testTasks, 'oldIndex');
    RangeError.checkValidIndex(newIndex, testTasks, 'newIndex');

    final String item = testTasks!.removeAt(oldIndex);
    testTasks.insert(newIndex, item);

    final bool value = tasksIsDoneList!.removeAt(oldIndex);
    tasksIsDoneList.insert(newIndex, value);

    _loggedInUser.tasks = testTasks;
    _loggedInUser.tasksIsDone = tasksIsDoneList;

    postChangeToFirebase(firebaseFirestore);
  }

  static void changeTaskIsDone(
      bool isDone, int _index, FirebaseFirestore firebaseFirestore) async {
    _loggedInUser.tasksIsDone![_index] = !_loggedInUser.tasksIsDone![_index];
    postChangeToFirebase(firebaseFirestore);
  }

  //syncronize
  static void postChangeToFirebase(FirebaseFirestore firebaseFirestore) async {
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(_loggedInUser.toMap())
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  static Future<void> getChangeOnFirebase(
      Function setState, FirebaseFirestore firebaseFirestore) async {
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) => _loggedInUser = UserModel.fromMap(value.data()));
    setState();
  }
}
