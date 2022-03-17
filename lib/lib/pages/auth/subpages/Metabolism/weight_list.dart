

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weaversmvp/models/user.dart';

class WeightListScreen extends StatefulWidget{

  Stream<List<Weight>>? weighStreamList;
  
  WeightListScreen({ this.weighStreamList});
  
  @override
  WeightListScreenState createState() {
   return WeightListScreenState();
  }


}

class WeightListScreenState extends State<WeightListScreen>{


    @override
    Widget build(BuildContext context){
      return StreamBuilder<List<Weight>?>(builder: (contex, snapshot){
        List<Weight> weights = snapshot.data ?? [];
        return Container(
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
      }, stream: widget.weighStreamList,);
    }
}