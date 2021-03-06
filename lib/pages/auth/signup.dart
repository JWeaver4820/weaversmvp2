import 'package:flutter/material.dart';
import 'package:weaversmvp/operations/authenticate.dart';
import 'package:weaversmvp/sharing/load.dart';

//Create the SignUp class used for signing up to the application for the first time
class SignUp extends StatefulWidget {

  //Instantiate toggleview function for whether signin or signup is toggled
  final Function toggleView;
  SignUp({ required this.toggleView });
  //Create state for signing up
  @override
  _SignUpState createState() => _SignUpState();

}

//Create class for signing up
class _SignUpState extends State<SignUp> {

  //Create operation and key request used for authentication
  final AuthService _auth = AuthService();
  final _needKey = GlobalKey<FormState>();

  //Instantiate field states
  String error = '';
  bool loading = false;
  String email = '';
  String password = '';

  //Create the widget for signing up
  @override
  Widget build(BuildContext context) {

    //Create scaffold for the sign up page
    return loading ? Loading() : Scaffold(
      //Add style to the background of the scaffold
      backgroundColor: Colors.teal[200],
      appBar: AppBar(

        //Add style to the bar at the top of the screen
        backgroundColor: Colors.teal[600],
        elevation: 0.5,
        title: const Text('Sign Up to Diet Daddy'),
        actions: <Widget>[

          //Create the icon asking the user to sign in, in upper right
          TextButton.icon(
            //Add style to the sign in button
            style: TextButton.styleFrom(primary: Colors.teal[50]),
            icon: const Icon(Icons.person),
            label: const Text('Sign In'),
            onPressed: () => widget.toggleView(),

          ),

        ],

      ),

      //Create container for the form, asking the user to sign up with email and password
      body: Container(
        //Create spacing for the UI
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 60.0),
        child: Form(
          key: _needKey,
          child: Column(
            children: <Widget>[
              //Create the box for entering email widget and assign properties
              const SizedBox(height: 25.0),
              TextFormField(
                //Assign properties for the email requirements and validation
                validator: (value) => value!.isEmpty? 'Please enter your email address' : null,
                onChanged: (value) {
                  //Set state of email
                  setState(() => email = value);
                },

              ),
              //Create the box for entering password widget and assign properties
              const SizedBox(height: 25.0),
              TextFormField(
                //Assign properties for the password requirements and validation, including obscurity
                obscureText: true,
                validator: (value) => value!.length < 8 ? 'Enter a password 8+ chars long' : null,
                onChanged: (value) {
                  //Set state of password
                  setState(() => password = value);
                },

              ),

              //Create the box for signing in, which includes an elevated button
              const SizedBox(height: 25.0),
              //Sign Up button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                       //The color for the button  
                       primary: Colors.teal[600], 
                       //The color on click for sign in button
                       onPrimary: Colors.black, 
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.teal[50]),
                ),
                //Create state for username / password creation - authentication, store in Firebase database
                onPressed: () async {
                  if(_needKey.currentState!.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerEmailAndPassword(email, password);
                    if(result == null) {
                      setState(() {
                        loading = false;
                        error = 'This email is invalid or already exists';
                      });
                    }
                  }
                }
              ),
              //Create case for noInput
              const SizedBox(height: 14.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}