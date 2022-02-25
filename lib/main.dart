import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register/screens/home_screen.dart';

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
      home: const HomeScreen(),
    );
  }

  ThemeData baisTheme() {
    final basisTheme = ThemeData.dark();
    return basisTheme.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      splashColor: Colors.red,
      cardColor: Colors.grey[900],
      canvasColor: Colors.grey[900],
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.orange,
        primary: Colors.red,
        outline: Colors.white,
        onBackground: Colors.blue,
      ),
    );
  }
}
