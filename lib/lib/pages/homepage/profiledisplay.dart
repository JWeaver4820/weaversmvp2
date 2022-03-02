import 'package:weaversmvp/modeling/daddy.dart';
import 'package:flutter/material.dart';

//Create the widget that displays all of the users profile information they have entered
class ProfileDisplay extends StatelessWidget {

  final DietDaddy profileInfo;
  ProfileDisplay({ required this.profileInfo });

  @override
  Widget build(BuildContext context) {
    List<Widget> lines = [];
    lines.add( Text('Currently exercises ${profileInfo.numDaysExercised} days per week'));
    if(profileInfo.age != null) lines.add(Text('Is ${profileInfo.age} years old'));
    lines.add(Text(profileInfo.weight));
    lines.add(Text(profileInfo.height));
    lines.add(Text(profileInfo.targetBodyWeight));

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),

      child: Card(
        margin: EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 0.0),
//Name, Age, Weight, Height, and Goal (TBW Target Body Weight)
        child: ListTile(
          title: Text(profileInfo.name),
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