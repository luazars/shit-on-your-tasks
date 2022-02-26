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

  static List<Task> mapToTask(List<Map<String, dynamic>> taskMap) {
    List<Task> tasks = List.empty(growable: true);
    for (var i = 0; i < taskMap.length; i++) {
      tasks.add(Task(taskMap[i]["title"], taskMap[i]["text"],
          taskMap[i]["isDone"], taskMap[i]["color"], taskMap[i]["index"]));
    }
    return tasks;
  }
}
