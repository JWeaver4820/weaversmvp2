import 'package:flutter/material.dart';
import 'package:weaversmvp/operations/authenticate.dart';
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/pages/auth/signup.dart';
import 'package:weaversmvp/pages/homepage/home_page_screen.dart';
import 'package:weaversmvp/pages/homepage/home_screen_viewmodel.dart';
import 'package:weaversmvp/sharing/load.dart';
import 'package:weaversmvp/utils/page_transition.dart';
import 'package:weaversmvp/utils/prefs_manager.dart';

//Create the SignIn class used for signing in to the application after signing up
class SignIn extends StatefulWidget {

  //Instantiate toggleview function for whether signin or signup is toggled
  Function? toggleView;
  SignIn({ this.toggleView });
  

  //Create state for signing in
  @override
  _SignInState createState() => _SignInState();

}

//Create class for signing in
class _SignInState extends State<SignIn> {

//Create operation and key request used for authentication
final AuthService _authenticating = AuthService();
final _needKey = GlobalKey<FormState>();

//Instantiate field states
String noInput = '';
bool loading = false;
String email = '';
String password = '';
 
  //Create the widget for signing in
  @override
  Widget build(BuildContext context) {

    //Create scaffold for the sign in page
    return loading ? Loading() : Scaffold(

      //Add style to the background of the scaffold
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        
        //Add style to the bar at the top of the screen
        backgroundColor: Colors.teal[600],
        elevation: 0.5,
        title: const Text('Sign In to Diet Daddy'),
        actions: <Widget>[

          //Create the icon asking the user to sign up, in upper right
          TextButton.icon(

            //Add style to the sign up button
            style: TextButton.styleFrom(primary: Colors.teal[50]),
            icon: Icon(Icons.person),
            label: Text('Sign Up'),
            onPressed: () => {
              Navigator.pushReplacement(context, PageTransition(widget: SignUp()))
            }
          ),

        ],

        ),
        
        //Create container for the form, asking the user to sign in with email and password
        body:Container(

         //Create spacing for the UI
         padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 60.0),
         child:Form(
           key: _needKey,
           child: Column(
             children: <Widget>[

               //Create the box for entering email widget and assign properties
               const SizedBox(height: 25.0),
               TextFormField(   

                //Assign properties for the email requirements and validation
                validator: (value) => value!.isEmpty? 'Please enter your email address': null,
                onChanged: (value){

                  //Set state of email
                  setState(() => email = value);

                },

              ),

               //Create the box for entering password widget and assign properties
               const SizedBox(height: 25.0),
               TextFormField(  

                //Assign properties for the password requirements and validation, including obscurity
                obscureText: true, 
                validator: (value) => value!.length < 8 ? 'Password must be at least 8 digits': null,
                onChanged: (value){

                  //Set state of password
                  setState(() => password = value);

                },

              ),

              //Create the box for signing in, which includes an elevated button
              const SizedBox(height: 25.0),

              //Sign In button
              ElevatedButton(
                style: ElevatedButton.styleFrom(

                //The color for the button  
                primary: Colors.teal[600], 

                //The color on click for sign in button
                onPrimary: Colors.black,
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(color: Colors.teal[50]),
                ),

                //Create state for username / password invalid - authentication
                onPressed: () {
                 if(_needKey.currentState!.validate()){                
                    _authenticating.signInWithEmailAndPassword(email, password, (user){
                     if(user == null){
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User data is empty")));
                   }else{
                    // UserManager.saveUser(user);
                           Navigator.of(context).pushAndRemoveUntil(PageTransition(widget: 
                            HomePageScreen(homeScreenViewModel: HomeScreenViewModel(DatabaseService(), PrefsManager()) ,)),
                             (se) => false);
                  
                   }

                    });
                  
                }
                
                
                }),
                
                //Create case for noInput
                const SizedBox(height: 14.0),
                Text(
                  noInput,
                  style:  TextStyle(color: Colors.red[400], fontSize: 12.0),
                )
             ],
           ))
         
      )
    );
  }
}