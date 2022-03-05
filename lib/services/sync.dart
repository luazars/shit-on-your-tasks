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

  static Future<void> getDataFirebase(
      List<Task> tasks, Function setState) async {
    tasks = (await Firebase.pullFromFirebase())!;
    tasks.sort((a, b) => a.index.compareTo(b.index));
    setState();
  }

  static sync(List<Task> tasks) {
    LocalData.savePref(tasks);
    syncFirebase(tasks);
  }
}
