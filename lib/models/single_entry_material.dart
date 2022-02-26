import "package:flutter/material.dart";
import 'package:login_register/models/task_model.dart';

class SingleEntry extends StatelessWidget {
  final Task _task;
  final Function _setState;

  const SingleEntry(this._task, this._setState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        hoverColor: Colors.red,
        leading: Checkbox(
          value: _task.isDone,
          onChanged: (value) => _setState(_task.isDone = !_task.isDone),
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
