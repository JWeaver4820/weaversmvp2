import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart';
import 'package:weaversmvp/pages/auth/subpages/Metabolism/weight_list.dart';
import 'package:weaversmvp/pages/auth/subpages/profile_screen.dart';
import 'package:weaversmvp/pages/homepage/home_screen_viewmodel.dart';

import '../../../../operations/database.dart';
import '../../../../weight_scheduler/weight_screen.dart';

/*class MetabolismScreen extends StatefulWidget{
  @override
  MetabolismScreenState createState() {
    return MetabolismScreenState();
  }


}*/

class MetabolismScreen extends StatelessWidget{

  MetabolismScreen();


  BehaviorSubject<int> _pages = BehaviorSubject();

  int page = -1;

  @override
  Widget build(BuildContext context) {
   // DatabaseService().getWeights();
   return FutureBuilder<List<Weight>>(builder: (_, snapshot){


     print("snapshotE => ${snapshot.error}");

    print("snapshot => ${snapshot.data}");

     List<Widget> subPages = [WeightListScreen(weighList : snapshot.data,)];

     return StreamBuilder<int>(builder: (_, snapshot){

       return WillPopScope(child: page < 0 ? Column(
         children: [
           _buildButton("Weekly Recorded Weight", () {

             _pages.sink.add(page++);
           }),
           _buildButton("Weight Chart", () {

             _pages.sink.add(page++);
           }),
           _buildButton("Current State of Metabolism and Suggestions", () {

             _pages.sink.add(page++);
           })

         ],
       ): subPages[page], onWillPop: () async {

         if(page >= 0){
           _pages.sink.add(page--);
           return false;
         }else{

           return true;
         }
       });
     }, stream: _pages.stream, initialData: -1,);
   }, future: DatabaseService().getWeights(),);
  }

  Widget _buildButton(String title, Function()? onTap){
    return ElevatedButton(onPressed: (){onTap?.call();},
     child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),), style: ButtonStyle(
       backgroundColor: MaterialStateProperty.all(Colors.teal)
     ),);
  }

  void openWeightListScreen(){

  }

  /*
       backgroundColor: MaterialStateProperty.all(Colors.teal)

  */

}