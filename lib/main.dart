import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register/screens/home_screen.dart';
import 'package:login_register/screens/route_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//<a href="https://www.flaticon.com/free-icons/to-do-list" title="to do list icons">To do list icons created by Freepik - Flaticon</a>

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Simple:Tasks",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const RoutePage(),
    );
  }

  // ThemeData darkTheme() {
  //   final darkTheme = ThemeData.dark();
  //   return darkTheme.copyWith(
  //       colorScheme: ColorScheme.fromSwatch().copyWith(
  //     // primary: Color.fromARGB(255, 150, 21, 224),
  //     // secondary: Colors.blueAccent,
  //     outline: Colors.white,
  //     onBackground: Colors.blue,
  //   ));
  // }
}
