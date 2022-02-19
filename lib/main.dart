import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "login",
      theme: baisTheme(),
      home: const LoginScreen(),
    );
  }

  ThemeData baisTheme() {
    final basisTheme = ThemeData.light();
    return basisTheme.copyWith(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.grey[300],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.black,
        primary: Colors.black,
      ),
    );
  }
}
