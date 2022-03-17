import 'package:flutter/material.dart' ;
import 'package:weaversmvp/operations/authenticate.dart';
import 'package:weaversmvp/pages/homepage/settingsform.dart';
import 'package:provider/provider.dart';
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/modeling/daddy.dart';
import 'package:weaversmvp/pages/homepage/dietlist.dart';
 
 //Create class for the home page
 class Homepage extends StatelessWidget {

   Homepage({ Key? key }) : super(key: key);
   final AuthService _authService = AuthService();
  
  //Create the widget for building the home page, once signed up and logged in
  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {

      showModalBottomSheet(

        context: context, builder: (context) {

        return Container(

          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),

        );

      }

      );

    }

    //This stream provider is returning the firebase backend data
    return StreamProvider<List<DietDaddy>>.value(

      value: DatabaseService().diets,
      initialData: const [],

      child: Scaffold(

        backgroundColor: Colors.teal[50],
        appBar: AppBar(

          title: const Text('Home'),
          backgroundColor: Colors.teal[600],
          elevation: 0.0,
          actions: <Widget>[

            TextButton.icon(

              style: TextButton.styleFrom(primary: Colors.teal[50]),
              icon: const Icon(Icons.person),
              label: const Text('Sign Out'),

              onPressed: () async {
                await _authService.signOut();
              },

            ),

            TextButton.icon(

              style: TextButton.styleFrom(primary: Colors.teal[50]),
              icon: const Icon(Icons.settings),
              label: const Text('Edit Profile'),
              onPressed: () => _showSettingsPanel(),

            )

          ],

        ),

        body: Container(

          decoration: const BoxDecoration(

            image: DecorationImage(

              image: AssetImage('assets/dietdaddy.png'),
              fit: BoxFit.cover,

            ),

          ),

          child: DietList()

        ),
        
      ),

    );

  }

 }