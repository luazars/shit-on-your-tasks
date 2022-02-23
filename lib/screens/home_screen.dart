import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_register/screens/add_task_screen.dart';
import 'package:login_register/shared/bg_widget.dart';
import '../models/single_entry_material.dart';
import '../services/firebase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  setStateOnHomescreen() => setState(() {});
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    Firebase.getChangeOnFirebase(setStateOnHomescreen, _firebaseFirestore);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      Scaffold(
        appBar: AppBar(
          title: Text(
              "Welcome back ${Firebase.loggedInUser.firstName} ${Firebase.loggedInUser.secondName}"),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {
                  Firebase.logout(context, _auth);
                }),
          ],
        ),
        body: ReorderableListView.builder(
          onReorder: ((oldIndex, newIndex) =>
              Firebase.reorderTiles(oldIndex, newIndex, _firebaseFirestore)),
          itemCount: Firebase.loggedInUser.tasks?.length ?? 0,
          primary: true,
          padding: const EdgeInsets.all(10),
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ValueKey(
                index.toString() + Firebase.loggedInUser.tasks?[index],
              ),
              onDismissed: (value) {
                setState(() {
                  Firebase.removeEntryFromFirestore(index, _firebaseFirestore);
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
                  SingleEntry(Firebase.loggedInUser.tasks?[index], index,
                      setStateOnHomescreen, _firebaseFirestore),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => AddTaskScreen(
                      setStateOnHomescreen, _firebaseFirestore))));
            });
          }),
          child: const Icon(
            Icons.add_rounded,
          ),
        ),
      ),
    );
  }
}
