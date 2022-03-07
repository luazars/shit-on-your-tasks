import 'package:login_register/models/task_model.dart';
import 'package:login_register/services/shared_preferences.dart';

import 'firebase.dart';

class Sync {
  static syncFirebase(List<Task> tasks) async {
    await Firebase.clearTasksOnFirebase();
    for (var i = 0; i < tasks.length; i++) {
      await Firebase.pushToFirebase(tasks[i]);
    }
  }

  static Future<List<Task>> getDataFirebase(List<Task> tasks) async {
    tasks = (await Firebase.pullFromFirebase())!;
    tasks.sort((a, b) => a.index.compareTo(b.index));

    return tasks;
  }

  static sync(List<Task> tasks) {
    LocalData.savePref(tasks);
    syncFirebase(tasks);
  }
}
