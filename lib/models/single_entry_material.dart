import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

import '../services/firebase.dart';

class SingleEntry extends StatelessWidget {
  final String _title;
  final int _index;
  final Function setState;
  final FirebaseFirestore firebaseFirestore;

  const SingleEntry(
      this._title, this._index, this.setState, this.firebaseFirestore,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        hoverColor: Colors.red,
        leading: Checkbox(
          value: Firebase.loggedInUser.tasksIsDone![_index],
          onChanged: (value) {
            Firebase.changeTaskIsDone(value!, _index, firebaseFirestore);
            setState();
          },
        ),
        title: Text(_title),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
    );
  }
}
