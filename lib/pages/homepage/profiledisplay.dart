import 'package:weaversmvp/modeling/daddy.dart';
import 'package:flutter/material.dart';

//Create the widget that displays all of the users profile information they have entered
class ProfileDisplay extends StatelessWidget {

  final DietDaddy diet;
  ProfileDisplay({ required this.diet });

  @override
  Widget build(BuildContext context) {
    List<Widget> lines = [];
    lines.add( Text('Currently exercises ${diet.numDaysExercised} days per week'));
    if(diet.age != null) lines.add(Text('Is ${diet.age} years old'));
    lines.add(Text(diet.weight));
    lines.add(Text(diet.height));
    lines.add(Text(diet.targetBodyWeight));

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),

      child: Card(
        margin: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 0.0),
//Name, Age, Weight, Height, and Goal (TBW Target Body Weight)
        child: ListTile(
          title: Text(diet.name),
          subtitle: Expanded(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: lines,
            ) ,
          ) ,
        )
      ),
    );

  }

}