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
      theme: ThemeData.dark(),
      // home: const RoutePage(),
      home: const HomeScreen(false),
    );
  }

  // ThemeData baisTheme() {
  //   final baisTheme = ThemeData.dark();
  //   return baisTheme.copyWith(
  //       colorScheme: ColorScheme.fromSwatch().copyWith(
  //     // primary: Color.fromARGB(255, 150, 21, 224),
  //     // secondary: Colors.blueAccent,
  //     outline: Colors.white,
  //     onBackground: Colors.blue,
  //   ));
  // }
}
