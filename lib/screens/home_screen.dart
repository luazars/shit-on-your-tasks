import 'package:flutter/material.dart';
import 'package:login_register/screens/add_task_screen.dart';

import '../models/single_entry_material.dart';
import '../services/firebase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  setStateOnHomescreen() => setState(() {});

  @override
  void initState() {
    super.initState();
    Firebase.getChangeOnFireBase(setStateOnHomescreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Welcome back ${Firebase.getUser().firstName} ${Firebase.getUser().secondName}"),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {
                  Firebase.logout(context);
                }),
          ],
        ),
        body: ReorderableListView.builder(
          onReorder: ((oldIndex, newIndex) =>
              Firebase.reorderTiles(oldIndex, newIndex)),
          itemCount: Firebase.getUser().tasks?.length ?? 0,
          primary: true,
          padding: const EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey(
                index.toString() + Firebase.getUser().tasks?[index],
              ),
              onDismissed: (value) {
                setState(() {
                  Firebase.removeEntryFromFirestore(index);
                });
              },
              background: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.delete_rounded,
                    ),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SingleEntry(Firebase.getUser().tasks?[index], index,
                      setStateOnHomescreen),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => AddTaskScreen(setStateOnHomescreen))));
            });
          }),
          child: const Icon(
            Icons.add_rounded,
          ),
        ));
  }
}
