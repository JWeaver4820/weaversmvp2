import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moving_average/moving_average.dart';
import 'package:weaversmvp/models/user.dart' as model;

class WeightEvaluationScreen extends  StatefulWidget{

  num? movingAvgDiff;

  Stream<model.User>? userProfile;

  WeightEvaluationScreen(this.movingAvgDiff,{Key? key, required this.userProfile});

  @override
  WeightEvaluationScreenState createState() {
    return WeightEvaluationScreenState();
  }

}

class WeightEvaluationScreenState extends State<WeightEvaluationScreen> {


  late num movingAvgDiff;

  num maintenanceCalories = -1;

  @override
  Widget build(BuildContext context) {
    movingAvgDiff = widget.movingAvgDiff ?? -1;

    return StreamBuilder<model.User>(builder: (_, snapshot) {
      final profile = snapshot.data;

      if(!snapshot.hasData){
        return const Center(child: CircularProgressIndicator(),);
      }

      if (maintenanceCalories != (profile?.maintenanceCalories ?? 0)) {
        maintenanceCalories = (profile?.maintenanceCalories ?? 0);
      }

      String recChanges = '';
      String stateMetabolism = '';
      num dailyCals = 0;

      if (snapshot.data != null) {
        final model.User value = snapshot.requireData;
        if (value.gainWeight != null) {
          if (movingAvgDiff < 0.5) {
            stateMetabolism = "Increasing";
            recChanges = 'Increase maintenance calories by 10';
            maintenanceCalories += 100;
          } else if (movingAvgDiff > 1.5) {
            stateMetabolism = "Decreasing";
            recChanges = 'Decrease maintenance calories by 100';
            maintenanceCalories -= 100;
          } else if (movingAvgDiff > 0.5 && movingAvgDiff < 1.5) {
            stateMetabolism = "Consistent!";
            recChanges = "None, keep following the Meal Plan!";
          }
          dailyCals = maintenanceCalories + 500;
        } else if (value.loseWeight != null) {
          if (movingAvgDiff > -0.5) {
            stateMetabolism = "Decreasing";
            maintenanceCalories -= 100;
            recChanges = "Increase maintenance calories by 100";
          } else if (movingAvgDiff < -1.5) {
            stateMetabolism = "Increasing";
            maintenanceCalories += 100;
            recChanges = "Decrease maintenance calories by 100";
          } else if (movingAvgDiff < -0.5 && movingAvgDiff > -1.5) {
            stateMetabolism == "Consistent!";
            recChanges == "None, keep following the Meal Plan!";
          }
          dailyCals = maintenanceCalories - 500;
        } else if (value.maintainWeight != null) {
          if (movingAvgDiff > 1) {
            stateMetabolism = "Decreasing";
            maintenanceCalories -= 100;
            recChanges == "Decrease maintenance calories by 100";
          } else if (movingAvgDiff < -1) {
            stateMetabolism = "Increasing";
            maintenanceCalories += 100;
            recChanges = "Increase maintenance calories by 100";
          } else if (movingAvgDiff < 1 && movingAvgDiff > -11) {
            stateMetabolism == "Consistent!";
            recChanges == "None, keep following the Meal Plan!";
          }
          dailyCals = maintenanceCalories;
        }

        print("hello => ${profile?.weights?.createdAt}");
       // final date = DateTime.parse("${profile?.weights?.createdAt}");
      }

      return Column(
        children: [
          /* LAST WEIGHT + 7 DAYS */
          buildItem("Date of Next Evaluation:",
              "7 DAYS + LAST WEIGHT CHECK IN:  DAY(S)"), //CreatedAt + 7 DAYS
          /*
          *   if GOAL == gain weight
                 && if result < .5
                   stateMetabolism = "Increasing";
                    maintenanceCalories += 100;
                      recChanges = "Increase maintenance calories by 100";
                 OR if result > 1.5
                   stateMetabolism == "Decreasing";
                    maintenanceCalories -= 100;
                      recChanges == "Decrease maintenance calories by 100";
                    else if result > 0.5 && < 1.5
                    stateMetabolism == "Consistent!";
                      recChanges == "None, keep following the Meal Plan!";

              if GOAL == lose weight
                 && if result > -0.5
                   stateMetabolism = "Decreasing";
                    maintenanceCalories -= 100;
                      recChanges = "Increase maintenance calories by 100";
                 OR if result < -1.5
                   stateMetabolism = "Increasing";
                    maintenanceCalories += 100;
                      recChanges == "Decrease maintenance calories by 100";
                    else if result < -0.5 && > -1.5
                    stateMetabolism == "Consistent!";
                      recChanges == "None, keep following the Meal Plan!";

*               if GOAL == maintain weight
                 && if result > 1
                   stateMetabolism = "Decreasing";
                    maintenanceCalories -= 100;
                      recChanges == "Decrease maintenance calories by 100";
                 OR if result < -1
                   stateMetabolism = "Increasing";
                    maintenanceCalories += 100;
                      recChanges = "Increase maintenance calories by 100";
                    else if result < 1 && > -1
                    stateMetabolism == "Consistent!";
                      recChanges == "None, keep following the Meal Plan!";
          *
          * */

          buildItem("State of Metabolism:", stateMetabolism),
          buildItem("Recommended Changes:", recChanges),
          buildItem("Grams protein per day:", "${dailyCals*.3/4}"), // dailyCals/4
          buildItem("Grams carbs per day:", "${dailyCals*.4/4}"), // dailyCals/4
          buildItem("Grams fat per day:", "${dailyCals*.3/9}") // dailyCals/9
        ],
      );
    },
      stream: widget.userProfile,
    );
  }

  Widget buildItem(String title, String subTitle) {
    return ListTile(
      minVerticalPadding: 10,
      title: Text(title),
      subtitle: Text(subTitle),
    );
  }

}