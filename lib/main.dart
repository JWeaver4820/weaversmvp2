import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/pages/welcome/welcome.dart';

//Main method, run, debug, profile
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//Create the MyApp class
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Welcome(),
    );
  }
}
