import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart';
import 'package:weaversmvp/pages/auth/subpages/Metabolism/weight_chart.dart';
import 'package:weaversmvp/pages/auth/subpages/Metabolism/weight_evaluation.dart';
import 'package:weaversmvp/pages/auth/subpages/Metabolism/weight_list.dart';
import 'package:weaversmvp/pages/auth/subpages/profile_screen.dart';
import 'package:weaversmvp/pages/homepage/home_screen_viewmodel.dart';

import '../../../../operations/database.dart';
import '../../../../weight_scheduler/weight_screen.dart';
import 'package:charts_flutter/flutter.dart' as chart;

/*class MetabolismScreen extends StatefulWidget{
  @override
  MetabolismScreenState createState() {
    return MetabolismScreenState();
  }


}*/

class MetabolismScreen extends StatelessWidget{

  MetabolismScreen();


  BehaviorSubject<Widget?> _newPage = BehaviorSubject();


  @override
  Widget build(BuildContext context) {
   // DatabaseService().getWeights();
    Widget screen;
   return FutureBuilder<List<Weight>>(builder: (_, weightSnapsot){


     return StreamBuilder<Widget?>(builder: (_, snapshot){

       return WillPopScope(child: snapshot.data == null ? Column(
         children: [
           _buildButton("Weekly Recorded Weight", () {
             _newPage.sink.add(WeightListScreen(weighList : weightSnapsot.data,));
           }),
           _buildButton("Weight Chart", () {

             _newPage.sink.add(WeightChart.startWithData(weightList: weightSnapsot.data,));
           }),
           _buildButton("Current State of Metabolism and Suggestions", () {

             _newPage.sink.add(WeightEvaluationScreen());
           })

         ],
       ): snapshot.data!, onWillPop: () async {

         if(snapshot.data != null){
           _newPage.sink.add(null);
           return false;
         }else{

           return true;
         }
       });
     }, stream: _newPage.stream, );
   }, future: DatabaseService().getWeights(),);
  }

  void back(){
    _newPage.sink.add(null);
  }

  Widget _buildButton(String title, Function()? onTap){
    return ElevatedButton(onPressed: (){
      print("hellow => 33333");
      onTap?.call();
      },
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