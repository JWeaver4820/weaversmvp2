
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/models/user.dart' as model;

import 'home_screen_viewmodel.dart';

class HomePageScreen extends StatefulWidget{
  HomeScreenViewModel? homeScreenViewModel;

   HomePageScreen( {Key? key, this.homeScreenViewModel}) : super(key: key);

  @override
 HomePageScreenState createState() {
    return  HomePageScreenState();
  }

}

class HomePageScreenState extends State<HomePageScreen>{

    Widget get _defaultMargin  => const SizedBox(height: 30,);

  
  @override
  Widget build(BuildContext context) {
    widget.homeScreenViewModel?.getUserData();
    return Scaffold(
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
               // await _authService.signOut();
              },

            ),

            TextButton.icon(

              style: TextButton.styleFrom(primary: Colors.teal[50]),
              icon: const Icon(Icons.settings),
              label: const Text('Edit Profile'),
              onPressed: (){

              },

            )

          ],

        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
         child: Column(
      children:  [
        _buildProfileSnippet(),
        _defaultMargin,
        _buildTopButton(),
        _defaultMargin,
        Expanded(child: _buildBody(), flex: 0,)
      ],
    ),)),
    );
  }


  Widget _buildTopButton(){
    List<String> menus = ["Meal Plan", "Metabolism", "Profile"];
    return Row(
      children:menus.map((e) => Expanded(child:  Container
      (alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3)
      ),
       child: Text(e),
       ))).toList(),
    );
  }

  Widget _buildProfileSnippet(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      const Expanded(child: ClipRRect(child: Icon(Icons.ac_unit,
       color: Colors.amber, size: 100,), ), flex: 0,),
      Expanded(
      
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Text Text"),
             Text("Text Text2"),
                Text("Text Text3"),
                   Text("Text Text4"),
          
        ],
      ),)
      
    ],);
  }

  Widget _buildBody(){
    return StreamBuilder<model.User>(builder: (context, snapshot){
      final user = snapshot.data;
      return user == null ? const Center(child: CircularProgressIndicator(),): Column(
        children: [
          _buildItem(user.age),
          _buildItem(user.height),
          _buildItem(user.weight),
          _buildItem(user.targetBodyWeight)
        ],
      );
    }, stream: widget.homeScreenViewModel?.profile,);
  }

  Widget _buildItem(dynamic data){
    return Container(
  
  margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
        color: Colors.blueGrey
      ),
      child: Text(data.toString(), style: TextStyle(color: Colors.white) ), height: 40, width: double.maxFinite,);
  }

  @override
  void dispose() {
   widget.homeScreenViewModel?.dispose();
    super.dispose();
  }

}