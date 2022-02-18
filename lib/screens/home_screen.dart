import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:login_register/Backend/firebase.dart';
import 'package:login_register/Material/single_entry_material.dart';
import 'package:login_register/screens/add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
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
              "Welcome back ${Firebase.getUser().firstName} ${Firebase.getUser().secondName}!"),
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
          itemCount: Firebase.getUser().tasks!.length,
          primary: true,
          padding: const EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey("$index fdsaf ${Firebase.getUser().tasks![index]}"),
              onDismissed: (value) {
                setState(() {
                  Firebase.removeEntryFromFirestore(index);
                });
              },
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
          child: const Icon(Icons.add_rounded),
        ));
  }
}
