import 'package:flutter/material.dart';

class MealPlanScreen extends StatelessWidget{

  const MealPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: double.maxFinite, padding: EdgeInsets.all(20), child: Column(
      children: [
        _buildButton("This week grocery meal plan", () => null),
        _buildButton("This week grocery meal plan", () => null),
        _buildButton("This week grocery meal plan", () => null),
      ],
  ));
  }

  
  Widget _buildButton(String title, Function()? onTap){
    return ElevatedButton(onPressed: onTap,
     child: SizedBox(child:  Text(title, style: const TextStyle(fontSize: 16,
      fontWeight: FontWeight.w500),), width: double.maxFinite,), style: ButtonStyle(
       backgroundColor: MaterialStateProperty.all(Colors.teal)
     ),);
  }

}