import 'package:flutter/material.dart';
import 'package:weaversmvp/pages/auth/signin.dart';
import 'package:weaversmvp/pages/auth/signup.dart';

//create the Auth class which is used with the operations for authenticating
class Auth extends StatefulWidget {
  //Declare constructor as const, assign key
  const Auth({Key? key}) : super(key: key);

  //Create the state for the authentication
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  //Assign the status of log in as false boolean
  bool showLogIn = false;

  //Toggle the viewing state, whether or not logged in
  void toggleView() {
    setState(() => showLogIn = !showLogIn);
  }

  //Create widget for toggling authentication, whether log in or sign up is true
  @override
  Widget build(BuildContext context) {
    if (showLogIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
