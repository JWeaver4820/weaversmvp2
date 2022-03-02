import 'package:flutter/material.dart';

class MetabolismScreen extends StatelessWidget{
  const MetabolismScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Container(width: double.maxFinite, child: Column(
     children: [
            _buildButton("Weekly Recorded Weight", () => null),
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

}