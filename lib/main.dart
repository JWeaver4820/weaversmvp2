import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/pages/auth/signup.dart';
import 'package:weaversmvp/pages/auth/signin.dart';
import 'package:weaversmvp/pages/homepage/homepage.dart';
import 'package:weaversmvp/pages/welcome/welcome.dart';
import 'package:weaversmvp/pages/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:weaversmvp/modeling/user.dart';
import 'package:weaversmvp/operations/authenticate.dart';

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
      routes: {
        '/': (context) => Welcome(),
        '/signin': (context) => SignIn(),
        '/signup': (context) => SignUp(),
        '/homepage': (context) => Homepage(),
      },
    );
    /*return StreamProvider<FBUser?>.value(

      initialData: null,
      value: AuthService().userChange,

      builder: (context, snapshot) {

        ;

      }
    );*/
  }
}

