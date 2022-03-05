import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class LocalData {
  //*SharedPreferences Methods
  static void savePref(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listString = List.empty(growable: true);
    for (var i = 0; i < tasks.length; i++) {
      listString.add(jsonEncode(Task.taskToMap(tasks[i])));
    }
    prefs.setStringList("tasks", listString);
  }

  static void getPref(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listString = prefs.getStringList("tasks") ?? [];
    tasks.clear();
    for (var i = 0; i < listString.length; i++) {
      tasks.add(Task.mapToTask(jsonDecode(listString[i])));
    }
  }

  static void clearPref() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("tasks", []);
  }
}
