import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  RoutePageState createState() => RoutePageState();
}

class RoutePageState extends State<RoutePage> {
  bool isLoggedin = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() => isLoggedin = false);
      } else {
        setState(() => isLoggedin = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      isLoggedin == true ? const HomeScreen(false) : const LoginScreen();
}
