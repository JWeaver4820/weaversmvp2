import 'package:flutter/material.dart';
import 'package:weaversmvp/pages/auth/subpages/Metabolism/weight_list.dart';

import '../../../../operations/database.dart';

class MetabolismScreen extends StatefulWidget{
  @override
  MetabolismScreenState createState() {
    return MetabolismScreenState();
  }


}

class MetabolismScreenState extends State<MetabolismScreen>{


  List<Widget> subPages = [];

  int page = -1;

  @override
  Widget build(BuildContext context) {
    DatabaseService().getWeights();
   return Container(width: double.maxFinite, height: double.maxFinite, 
   child:  subPages.isNotEmpty ? Container(width: 100, height: 100, color: Colors.black): Column(
     children: [
            _buildButton("Weekly Recorded Weight", () {
                page +=1;
                subPages.add(WeightListScreen());
                setState(() { });
                print("Helloooo_ $page _ ${subPages.length}");
            }),
            _buildButton("Weight Chart", () => null),
            _buildButton("Current state of metabolism and suggestions", () => null)
     ],
   ));
  }

  Widget _buildButton(String title, Function()? onTap){
    return ElevatedButton(onPressed: onTap,
     child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),), style: ButtonStyle(
       backgroundColor: MaterialStateProperty.all(Colors.teal)
     ),);
  }

  void openWeightListScreen(){

  }

}