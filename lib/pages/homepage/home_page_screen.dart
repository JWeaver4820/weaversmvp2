
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/pages/auth/signup.dart';
import 'package:weaversmvp/pages/auth/subpages/mealplan.dart';
import 'package:weaversmvp/pages/auth/subpages/metabolism.dart';
import 'package:weaversmvp/pages/auth/subpages/profile_screen.dart';
import 'package:weaversmvp/pages/homepage/page_item.dart';
import 'package:weaversmvp/pages/homepage/settingsform.dart';
import 'package:weaversmvp/pages/welcome/welcome.dart';

import 'home_screen_viewmodel.dart';
import 'package:weaversmvp/utils/dart_exts.dart';

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

    final PageController _pageController = PageController();

    final homeScreenViewModel = HomeScreenViewModel(DatabaseService());


    @override
  void initState() {
    homeScreenViewModel.logOut.listen((event) {
      context.startNewTaskPage(child: Welcome());

    }, onError: (error){
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(error.toString())));
    });

    
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
 
   homeScreenViewModel.getUserData();

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
               homeScreenViewModel.signOut();
              },

            ),

            TextButton.icon(

              style: TextButton.styleFrom(primary: Colors.teal[50]),
              icon: const Icon(Icons.settings),
              label: const Text('Edit Profile'),
              onPressed: (){
                _showSettingsPanel();
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

  Widget _buildTopButton(){

    List<PageItem> menus = [PageItem(page: 0, title: "Meal Plan"),
     PageItem(page: 1, title: "Metabolic"),
      PageItem(page: 2, title:  "Profile")];
    return Row(
      children:menus.map((e) => Expanded(child: InkWell(
        onTap: (){
          // Change page
          _pageController.jumpToPage(e.page);
       
        },
        child: Container
      (alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 3)
      ),
       child: Text(e.title),
       ),
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
      flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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

    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: PageView(
        
      controller: _pageController,
        children: [
          const MealPlanScreen(),
         const MetabolismScreen(),
          ProfileScreen(homeScreenViewModel:  
         homeScreenViewModel
          )
        ],
    ));
  }


  @override
  void dispose() {
   homeScreenViewModel.dispose();
    super.dispose();
  }

}