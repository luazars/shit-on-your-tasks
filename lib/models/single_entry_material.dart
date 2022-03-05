import "package:flutter/material.dart";
import 'package:login_register/models/task_model.dart';

class SingleEntry extends StatelessWidget {
  final Task _task;
  final Function _setState, _reorder;

  const SingleEntry(this._task, this._setState, this._reorder, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: _task.text == "" ? 50 : 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: _task.isDone,
            activeColor: _task.color,
            checkColor:
                _task.color == Colors.white ? Colors.black : Colors.white,
            onChanged: (value) {
              _task.isDone = !_task.isDone;
              _setState();
              if (value == true) _reorder(_task);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      _task.title,
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
                if (_task.text != "")
                  Text(
                    _task.text.characters.length >= 30
                        ? _task.text.characters.getRange(0, 30).toString() +
                            "..."
                        : _task.text,
                    style: TextStyle(
                      fontWeight:
                          _task.isDone ? FontWeight.normal : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          if (!_task.isDone)
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
