import 'dart:ui';

class Task {
  String title;
  String text;
  bool isDone;
  Color color;
  int index;

  Task(this.title, this.text, this.isDone, this.color, this.index);

  static reorderTaskList(List _tasks, int _oldIndex, int _newIndex) {
    _oldIndex < _newIndex ? _newIndex -= 1 : null;

    final item = _tasks.removeAt(_oldIndex);
    _tasks.insert(_newIndex, item);
  }

  static Map<String, dynamic> taskToMap(Task task) {
    Map<String, dynamic> taskMap = {};
    taskMap["title"] = task.title;
    taskMap["text"] = task.text;
    taskMap["isDone"] = task.isDone;
    taskMap["color"] = <int>[
      task.color.red,
      task.color.green,
      task.color.blue,
      1 //full Opasity
    ];
    taskMap["index"] = task.index;

    return taskMap;
  }

  static Task mapToTask(Map<String, dynamic> taskMap) {
    return Task(
        taskMap["title"],
        taskMap["text"],
        taskMap["isDone"],
        Color.fromARGB(
            250, taskMap["color"][0], taskMap["color"][1], taskMap["color"][2]),
        taskMap["index"]);
  }
}
