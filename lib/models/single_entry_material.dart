import "package:flutter/material.dart";
import 'package:login_register/models/task_model.dart';

class SingleEntry extends StatelessWidget {
  final Task _task;
  final Function _setState;

  const SingleEntry(this._task, this._setState, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            value: _task.isDone,
            onChanged: (value) {
              _task.isDone = !_task.isDone;
              _setState();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  _task.title + _task.index.toString(),
                  style: TextStyle(
                    fontWeight:
                        _task.isDone ? FontWeight.normal : FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                if (_task.isDone)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: 3,
                      width: _task.title.characters.length * 10,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: _task.color,
            ),
            width: 30,
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
    );
  }
}
