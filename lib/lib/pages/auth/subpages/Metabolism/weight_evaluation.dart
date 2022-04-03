import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeightEvaluationScreen extends  StatefulWidget{

  WeightEvaluationScreen({Key? key});

  @override
  WeightEvaluationScreenState createState() {
    return WeightEvaluationScreenState();
  }

}

class WeightEvaluationScreenState extends State<WeightEvaluationScreen>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(builder: (_, snapshot){
      return Column(
        children: [
          buildItem("title", "subTitle1"),
          buildItem("title1", "subTitle1"),
          buildItem("title22", "subTitle123")
        ],
      );
    },);
  }

  Widget buildItem(String title, String subTitle){
    return ListTile(
      minVerticalPadding: 10,
      title: Text(title),
      subtitle: Text(subTitle),
    );
  }
}