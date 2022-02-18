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
    List? testTasks = loggedInUser.tasks;
    List? tasksIsDoneList = loggedInUser.tasksIsDone;
    testTasks?.add(task);
    tasksIsDoneList?.add(false);
    loggedInUser.tasks = testTasks;
    loggedInUser.tasksIsDone = tasksIsDoneList;
    makeFirebaseChange();
  }

  static UserModel getUser() {
    return loggedInUser;
  }

  static void removeEntryFromFirestore(int index) async {
    List? tasksList = loggedInUser.tasks;
    List? tasksIsDoneList = loggedInUser.tasksIsDone;
    tasksList?.removeAt(index);
    tasksIsDoneList?.removeAt(index);
    loggedInUser.tasks = tasksList;
    loggedInUser.tasksIsDone = tasksIsDoneList;
    makeFirebaseChange();
  }

  static void reorderTiles(int oldIndex, int newIndex) async {
    List? testTasks = loggedInUser.tasks;
    List? tasksIsDoneList = loggedInUser.tasksIsDone;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    RangeError.checkValidIndex(oldIndex, testTasks, 'oldIndex');
    RangeError.checkValidIndex(newIndex, testTasks, 'newIndex');

    final String item = testTasks!.removeAt(oldIndex);
    testTasks.insert(newIndex, item);

    final bool value = tasksIsDoneList!.removeAt(oldIndex);
    tasksIsDoneList.insert(newIndex, value);

    loggedInUser.tasks = testTasks;
    loggedInUser.tasksIsDone = tasksIsDoneList;

    makeFirebaseChange();
  }

  static void changeTaskIsDone(bool isDone, int _index) async {
    loggedInUser.tasksIsDone![_index] = !loggedInUser.tasksIsDone![_index];
    makeFirebaseChange();
  }

  static void makeFirebaseChange() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set(loggedInUser.toMap())
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  static postDetailsToFirestore(String firstName, String secondName) async {
    final _auth = FirebaseAuth.instance;
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

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .set(userModel.toMap())
        .onError((error, stackTrace) => print(error.toString()));
    Fluttertoast.showToast(msg: "Account succes");
  }
}
