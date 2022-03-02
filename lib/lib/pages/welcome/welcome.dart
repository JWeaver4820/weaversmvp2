import 'package:flutter/material.dart';
import 'package:weaversmvp/modeling/user.dart';
import 'package:weaversmvp/pages/auth/signin.dart';
import 'package:weaversmvp/pages/auth/signup.dart';
import 'package:weaversmvp/pages/homepage/homepage.dart';
import 'package:provider/provider.dart';
import 'package:weaversmvp/utils/page_transition.dart';


class Welcome extends StatefulWidget {
  //Create state for signing in
  @override
  _WelcomeState createState() => _WelcomeState();

}

//Create the wrapper class and keys
class _WelcomeState extends State<Welcome> {
  
  @override
  void initState() {
    super.initState();

    checkAuth();
  }

  void checkAuth() {
     final user = Provider.of<FBUser?>(context);
     if (user != null) {
       Navigator.push(context, PageTransition(widget: Homepage()));
       return;
     }
  }

  @override
 Widget build(BuildContext context) => Scaffold(
    //Create scaffold for the sign up page
      //Add style to the background of the scaffold
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        //Add style to the bar at the top of the screen
        backgroundColor: Colors.teal[600],
        elevation: 0.5,
        title: const Text('Welcome'),
      ),
      body: Container(
        alignment: Alignment(0,0),
        child: Column(children: <Widget>[
          
/*     Container(
        child: InkWell(
          onTap: () { 
            Navigator.push(context, PageTransition(widget: SignIn()));
          },
          child: Column(
            children: <Widget>[
                            PlainText("SIGNIN", fontSize: 12, textAlign: TextAlign.center, fontWeight: FontWeight.bold, ),
            ]
          ),
        )
      ), */
      
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
                //Create state for goals
               onPressed: () {
            Navigator.push(context, PageTransition(widget: SignUp()));

           }
              ),
       ElevatedButton(
                style: ElevatedButton.styleFrom(
                       //The color for the button  
                       primary: Colors.teal[600], 
                       //The color on click for sign in button
                       onPrimary: Colors.black, 
                ),
                
                child: Text(
                  'Sign In',
                  style: TextStyle(color: Colors.teal[50]),
                  
                ),
                //Create state for goals
               onPressed: () {
            Navigator.push(context, PageTransition(widget: SignIn()));

           }
              )
//begin
/*       Container(
        child: InkWell(
          onTap: () {
            Navigator.push(context, PageTransition(widget: SignUp()));

           },
          child: Column(
            children: <Widget>[
                            PlainText("SIGNUP", fontSize: 12, textAlign: TextAlign.center, fontWeight: FontWeight.bold, ),
            ]
          ),
        )
      ) */
      //end
          
        ],)
      ),
 );

}


class PlainText extends StatelessWidget {
  final String value;
  final double fontSize;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  PlainText(this.value, {required this.fontSize, required this.textAlign, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: this.textAlign != null ? this.textAlign : TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: this.fontWeight != null ? this.fontWeight : FontWeight.normal,
        fontSize: this.fontSize != null ? this.fontSize : 14.0,
        color: Colors.black
      ),
    );
  }
}
