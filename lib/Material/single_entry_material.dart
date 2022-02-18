import "package:flutter/material.dart";
import 'package:login_register/Backend/firebase.dart';
import 'package:login_register/screens/home_screen.dart';

class SingleEntry extends StatelessWidget {
  final String _title;
  final int _index;
  final Function setState;

  const SingleEntry(this._title, this._index, this.setState, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Container(
      child: ListTile(
        hoverColor: Colors.red,
        leading: Checkbox(
          value: Firebase.loggedInUser.tasksIsDone![_index],
          onChanged: (value) {
            Firebase.changeTaskIsDone(value!, _index);
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
