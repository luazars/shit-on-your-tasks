import "package:flutter/material.dart";
import 'package:login_register/models/task_model.dart';

class SingleEntry extends StatelessWidget {
  final Task _task;
  final Function setState;

  const SingleEntry(this._task, this.setState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        hoverColor: Colors.red,
        leading: Checkbox(
          value: _task.isDone,
          onChanged: (value) {
            _task.isDone = !_task.isDone;
            setState();
          },
        ),
        title: Text(_task.title),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _task.color,
      ),
    );
  }
}
