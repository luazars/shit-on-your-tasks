import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register/screens/home_screen.dart';
import 'package:login_register/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: baisTheme(),
      home: const RoutePage(),
    );
  }

  ThemeData baisTheme() {
    final baisTheme = ThemeData.dark();
    return baisTheme.copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(
      // primary: Color.fromARGB(255, 150, 21, 224),
      // secondary: Colors.blueAccent,
      outline: Colors.white,
      onBackground: Colors.blue,
    ));
  }
}

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
