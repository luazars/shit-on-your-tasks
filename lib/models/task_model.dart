import 'dart:ui';

class Task {
  String title;
  String text;
  bool isDone;
  Color color;

  Task(this.title, this.text, this.isDone, this.color);

  static reorder(List _tasks, int _oldIndex, int _newIndex) {
    _oldIndex < _newIndex ? _newIndex -= 1 : null;

    final item = _tasks.removeAt(_oldIndex);
    _tasks.insert(_newIndex, item);
  }
}
