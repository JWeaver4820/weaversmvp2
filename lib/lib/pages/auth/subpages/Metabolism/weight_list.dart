

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/models/user.dart';

class WeightListScreen extends StatefulWidget{

  List<Weight>? weighList;
  
  WeightListScreen({ this.weighList});
  
  @override
  WeightListScreenState createState() {
   return WeightListScreenState();
  }


}

class WeightListScreenState extends State<WeightListScreen>{


    @override
    Widget build(BuildContext context){

      final  List<Weight>? weights = widget.weighList;
      print("WEIGHTS => $weights");

      return weights == null || weights.isEmpty ? Container(): Container(
        height: 300,
        color: Colors.amber,
        child: Column(
          children: [
            ListView.builder(itemBuilder: (context, index){
              Weight weight =weights[index];
              return ListTile(

                title: Text(weight.weightValue.toString()),
              );
            }, itemCount: weights.length,
              shrinkWrap: true,)
          ],
        ),
      );
    }
}