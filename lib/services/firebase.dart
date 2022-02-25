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

  static registerNewUser(String _firstName, String _secondName,
      FirebaseAuth _auth, FirebaseFirestore _firebaseFirestore) async {
    User? _user = _auth.currentUser;

    List<String> _emptyStringList = List.empty();
    List<bool> _emptyBoolList = List.empty();

    UserModel userModel = UserModel();
    userModel.email = _user?.email;
    userModel.uid = _user?.uid;
    userModel.firstName = _firstName;
    userModel.secondName = _secondName;
    userModel.tasksTitle = _emptyStringList;
    userModel.tasksText = _emptyStringList;
    userModel.tasksColor = _emptyStringList;
    userModel.tasksIsDone = _emptyBoolList;

    await _firebaseFirestore
        .collection("users")
        .doc(_user?.uid)
        .set(userModel.toMap())
        .onError((error, stackTrace) =>
            Fluttertoast.showToast(msg: error.toString()));
  }

  //Task stuff in

  static void postNewTaskToFirebase(String _taskTitle, String _taskText,
      String _taskColor, FirebaseFirestore _firebaseFirestore) async {
    List? testTasks = _loggedInUser.tasksTitle;
    List? tasksIsDoneList = _loggedInUser.tasksIsDone;
    testTasks?.add(_taskTitle);
    tasksIsDoneList?.add(false);
    _loggedInUser.tasksTitle = testTasks;
    _loggedInUser.tasksIsDone = tasksIsDoneList;
    postChangeToFirebase(_firebaseFirestore);
  }

  static void removeEntryFromFirestore(
      int index, FirebaseFirestore firebaseFirestore) async {
    List? _tasksTitleList = _loggedInUser.tasksTitle;
    List? _tasksTextList = _loggedInUser.tasksText;
    List? _tasksColorList = _loggedInUser.tasksColor;
    List? _tasksIsDoneList = _loggedInUser.tasksIsDone;
    _tasksTitleList?.removeAt(index);
    _tasksTextList?.removeAt(index);
    _tasksColorList?.removeAt(index);
    _tasksIsDoneList?.removeAt(index);
    _loggedInUser.tasksTitle = _tasksTitleList;
    _loggedInUser.tasksText = _tasksTextList;
    _loggedInUser.tasksColor = _tasksColorList;
    _loggedInUser.tasksIsDone = _tasksIsDoneList;
    postChangeToFirebase(firebaseFirestore);
  }

  static void reorderTiles(
      int oldIndex, int newIndex, FirebaseFirestore firebaseFirestore) async {
    List? _tasksTitleList = _loggedInUser.tasksTitle;
    List? _tasksTextList = _loggedInUser.tasksText;
    List? _tasksColorList = _loggedInUser.tasksColor;
    List? _tasksIsDoneList = _loggedInUser.tasksIsDone;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    RangeError.checkValidIndex(oldIndex, _tasksTitleList, 'oldIndex');
    RangeError.checkValidIndex(newIndex, _tasksTitleList, 'newIndex');

    final String item = _tasksTitleList!.removeAt(oldIndex);
    _tasksTitleList.insert(newIndex, item);

    final bool value = _tasksIsDoneList!.removeAt(oldIndex);
    _tasksIsDoneList.insert(newIndex, value);

    _loggedInUser.tasksTitle = _tasksTitleList;
    _loggedInUser.tasksIsDone = _tasksIsDoneList;

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
