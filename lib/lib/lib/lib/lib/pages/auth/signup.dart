import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weaversmvp/dialogs/progress_dialog.dart';
import 'package:weaversmvp/models/user.dart';
import 'package:weaversmvp/operations/authenticate.dart';
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/pages/auth/signin.dart';
import 'package:weaversmvp/pages/homepage/home_screen_viewmodel.dart';
import 'package:weaversmvp/utils/page_transition.dart';
import 'package:weaversmvp/pages/homepage/home_page_screen.dart';
import 'package:weaversmvp/utils/prefs_manager.dart';

//Create the SignUp class used for signing up to the application for the first time
class SignUp extends StatefulWidget {
  //Instantiate toggleview function for whether signin or signup is toggled
  Function? toggleView;
  SignUp({this.toggleView});
  //Create state for signing up
  @override
  _SignUpState createState() => _SignUpState();
}

//Create class for signing up
class _SignUpState extends State<SignUp> {
  //Create operation and key request used for authentication
  final AuthService _auth = AuthService();
  final _needKey = GlobalKey<FormState>();

  //Instantiate field states
  //admin, misc fields
  String error = '';
  bool loading = false;
  String email = '';
  String password = '';
  int currentStep = 0;

  //int fields
  int? targetBodyWeight;
  int? height;
  int? weight;
  int? age;
  int? hoursSleep;
  int? daysExercise;
  int? maintenanceCalories;

  //String fields
  String? loseWeight;
  String? gainWeight;
  String? maintainWeight;

  String? gender;
  int? selectedGender;
  List<String> genders = ['Gender: Male', 'Gender: Female'];

  String? day;
  int? selectedDay;
  List<String> days = [
    'Grocery day: Sunday',
    'Grocery day: Monday',
    'Grocery day: Tuesday',
    'Grocery day: Wednesday',
    'Grocery day: Thursday',
    'Grocery day: Friday',
    'Grocery day: Saturday',
  ];

  String? jobActivity;
  int? selectedJobActivity;
  List<String> jobActivities = [
    'Not active at all at day job',
    'Slightly active at day job',
    'Active at day job',
    'Very active at day job',
  ];

  //bool fields
  bool breakfast = false;
  bool american = false;
  bool italian = false;
  bool mexican = false;
  bool chinese = false;

  //Create the widget for signing up
  @override
  Widget build(BuildContext context) => Scaffold(
        //Create scaffold for the sign up page
        //Add style to the background of the scaffold
        backgroundColor: Colors.teal[200],
        appBar: AppBar(
          //Add style to the bar at the top of the screen
          backgroundColor: Colors.teal[600],
          elevation: 0.5,
          title: const Text('Sign Up to Diet Daddy'),
          actions: <Widget>[
            //Create the icon asking the user to sign in, in upper right
            TextButton.icon(
                //Add style to the sign in button
                style: TextButton.styleFrom(primary: Colors.teal[50]),
                icon: const Icon(Icons.person),
                label: const Text('Sign In'),
                onPressed: () => {
                      Navigator.pushReplacement(
                          context, PageTransition(widget: SignIn()))
                    }),
          ],
        ),
        //Create container for the form, asking the user to sign up with email and password
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.teal),
          ),
          child: Stepper(
            type: StepperType.vertical,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: () {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                print('Completed');

                /// send data to server

              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepTapped: (step) => setState(() => currentStep = step),
            onStepCancel: currentStep == 0
                ? null
                : () => setState(() => currentStep -= 1),
            controlsBuilder: (context, details) {
              return Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  children: [
                    (currentStep != 0)
                        ? Expanded(
                            child: ElevatedButton(
                              child: Text('BACK'),
                              onPressed: onStepCancel,
                            ),
                          )
                        : SizedBox(width: 0.0, height: 0.0),
                    const SizedBox(width: 12),
                    (currentStep < getSteps().length - 1)
                        ? Expanded(
                            child: ElevatedButton(
                              child: Text('NEXT'),
                              onPressed: onStepContinue,
                            ),
                          )
                        : SizedBox(width: 0.0, height: 0.0),
                  ],
                ),
              );
            },
          ),
        ),
      );
  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: Text('About'),
          content: Column(
            children: <Widget>[
              Text(
                  'Diet Daddy was created because other applications require too much data input, spending up to 2 hours a day \n\nThere are too many buttons and options in other applications\n\nToo much thinking - researching meals to meet specific macros \n\nToo many options of how to diet - keep it simple with 30/40/30 !\n\nAll Diet Daddy meals are based on the 30% Protein, 40% Carbs, and 30% Fat diet\n\nRecommendations are static over time whereas Diet Daddy tracks your metabolism and will change your diet according to fluctuations\n\nA grocery list is provided weekly, no time spent creating this every week!\n\nRecipes and full meal plans are provided weekly from just 1 data point per week\n\n90% of weight change is diet related, regardless of how much you exercise!'),
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: Text('Goals'),
          content: Column(
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //The color for the button
                    primary: Colors.teal[600],
                    //The color on click for sign in button
                    onPrimary: Colors.black,
                  ),
                  child: Text(
                    'Lose Weight',
                    style: TextStyle(color: Colors.teal[50]),
                  ),
                  //Create state for goals
                  onPressed: loseWeight != null
                      ? null
                      : () {
                          setState(() {
                            loseWeight = "Goal: Lose Weight";
                            gainWeight = null;
                            maintainWeight = null;
                          });
                        }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //The color for the button
                    primary: Colors.teal[600],
                    //The color on click for sign in button
                    onPrimary: Colors.black,
                  ),
                  child: Text(
                    'Gain Weight',
                    style: TextStyle(color: Colors.teal[50]),
                  ),
                  //Create state for goals
                  onPressed: gainWeight != null
                      ? null
                      : () {
                          setState(() {
                            loseWeight = null;
                            gainWeight = "Goal: Gain Weight";
                            maintainWeight = null;
                          });
                        }),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //The color for the button
                    primary: Colors.teal[600],
                    //The color on click for sign in button
                    onPrimary: Colors.black,
                  ),
                  child: Text(
                    'Maintain Weight',
                    style: TextStyle(color: Colors.teal[50]),
                  ),
                  //Create state for goals
                  onPressed: maintainWeight != null
                      ? null
                      : () {
                          setState(() {
                            loseWeight = null;
                            gainWeight = null;
                            maintainWeight = "Goal: Maintain Weight";
                          });
                        }),
              DropdownButton(
                hint: Text('Target Body Weight (lbs)'),
                items: [
                  for (var i = 30; i <= 400; i++)
                    DropdownMenuItem(
                      child: Text(i.toString() + ' lbs'),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        targetBodyWeight = selected;
                      })
                    }
                },
                value: targetBodyWeight,
              ),
              /*TextFormField(
            controller: targetBodyWeight,
            decoration: InputDecoration(labelText: 'Target Body Weight (lbs)')
          ),*/
            ],
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: Text('Profile'),
          content: Column(
            children: <Widget>[
              DropdownButton(
                hint: Text('Height'),
                items: [
                  for (var i = 24; i <= 96; i++)
                    DropdownMenuItem(
                      child: Text(i.toString() + ' inches'),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        height = selected;
                      })
                    }
                },
                value: height,
              ),
              DropdownButton(
                hint: Text('Current Weight'),
                items: [
                  for (var i = 30; i <= 370; i++)
                    DropdownMenuItem(
                      child: Text(i.toString() + ' lbs'),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        weight = selected;
                      })
                    }
                },
                value: weight,
              ),
              DropdownButton(
                hint: Text('Age'),
                items: [
                  for (var i = 18; i <= 120; i++)
                    DropdownMenuItem(
                      child: Text(i.toString() + ' years'),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        age = selected;
                      })
                    }
                },
                value: age,
              ),
              DropdownButton(
                hint: Text('Hours Sleep'),
                items: [
                  for (var i = 1; i <= 16; i++)
                    DropdownMenuItem(
                      child: Text(i.toString() + ' hours'),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        hoursSleep = selected;
                      })
                    }
                },
                value: hoursSleep,
              ),
              DropdownButton(
                hint: Text('Gender'),
                items: [
                  for (var i = 0; i < genders.length; i++)
                    DropdownMenuItem(
                      child: Text(genders[i]),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        selectedGender = selected;
                        gender = genders[selected];
                      })
                    }
                },
                value: selectedGender,
              ),
              DropdownButton(
                hint: Text('Which day do you shop for groceries?'),
                items: [
                  for (var i = 0; i < days.length; i++)
                    DropdownMenuItem(
                      child: Text(days[i]),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        selectedDay = selected;
                        day = days[selected];
                      })
                    }
                },
                value: selectedDay,
              ),
              DropdownButton(
                hint: Text('Days per week of exercise?'),
                items: [
                  for (var i = 1; i <= 7; i++)
                    DropdownMenuItem(
                      child: Text(i.toString() + ' days per week'),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        daysExercise = selected;
                      })
                    }
                },
                value: daysExercise,
              ),
              DropdownButton(
                hint: Text('How active is your day job?'),
                items: [
                  for (var i = 0; i < jobActivities.length; i++)
                    DropdownMenuItem(
                      child: Text(jobActivities[i]),
                      value: i,
                    )
                ].toList(),
                onChanged: (int? selected) => {
                  if (selected != null)
                    {
                      setState(() {
                        selectedJobActivity = selected;
                        jobActivity = jobActivities[selected];
                      })
                    }
                },
                value: selectedJobActivity,
              ),
            ],
          ),
        ),
        Step(
            isActive: currentStep >= 3,
            title: Text('Foods for Next Meal Plan'),
            content: Column(
              children: <Widget>[
                Text('Choose at least 3'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: breakfast,
                      onChanged: (value) {
                        setState(() {
                          breakfast = value!;
                        });
                      },
                    ),
                    Text("Breakfast"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: american,
                      onChanged: (value) {
                        setState(() {
                          american = value!;
                        });
                      },
                    ),
                    Text("American"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: italian,
                      onChanged: (value) {
                        setState(() {
                          italian = value!;
                        });
                      },
                    ),
                    Text("Italian"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: mexican,
                      onChanged: (value) {
                        setState(() {
                          mexican = value!;
                        });
                      },
                    ),
                    Text("Mexican"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: chinese,
                      onChanged: (value) {
                        setState(() {
                          chinese = value!;
                        });
                      },
                    ),
                    Text("Chinese"),
                  ],
                ),
              ],
            )),
        Step(
            isActive: currentStep >= 4,
            title: Text('Maintenance Calories'),
            content: Column(
              children: <Widget>[
                Text(
                    'Please calculate your maintenance calories\nby using the calculator found at https://www.mayoclinic.org/healthy-lifestyle/weight-loss/in-depth/calorie-calculator/itt-20402304\n\n'),
                DropdownButton(
                  hint: Text('Maintenance Calories'),
                  items: [
                    for (var i = 500; i <= 10000; i = i + 100)
                      DropdownMenuItem(
                        child: Text(i.toString() + ' calories'),
                        value: i,
                      )
                  ].toList(),
                  onChanged: (int? selected) => {
                    if (selected != null)
                      {
                        setState(() {
                          maintenanceCalories = selected;
                        })
                      }
                  },
                  value: maintenanceCalories,
                ),
              ],
            )),
        Step(
          isActive: currentStep >= 5,
          title: Text('Sign Up'),
          content: Container(
            child: Form(
              key: _needKey,
              child: Column(
                children: <Widget>[
                  //Create the box for entering email widget and assign properties
                  const SizedBox(height: 25.0),
                  TextFormField(
                    //Assign properties for the email requirements and validation
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your email address'
                        : null,
                    onChanged: (value) {
                      //Set state of email
                      setState(() => email = value);
                    },
                  ),
                  //Create the box for entering password widget and assign properties
                  const SizedBox(height: 25.0),
                  TextFormField(
                    //Assign properties for the password requirements and validation, including obscurity
                    obscureText: true,
                    validator: (value) => value!.length < 8
                        ? 'Enter a password 8+ chars long'
                        : null,
                    onChanged: (value) {
                      //Set state of password
                      setState(() => password = value);
                    },
                  ),

                  //Create the box for signing in, which includes an elevated button
                  const SizedBox(height: 25.0),
                  //Sign Up button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //The color for the button
                        primary: Colors.teal[600],
                        //The color on click for sign in button
                        onPrimary: Colors.black,
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.teal[50]),
                      ),
                      //Create state for username / password creation - authentication, store in Firebase database
                      onPressed: () async {
                        if (_needKey.currentState!.validate()) {
                          //
                          Dialogs.showLoading(context);
                          // ToDo: push state to firebase
                          final user = User(
                              //Integer variables pushed to Firebase
                              age: age,
                              height: height,
                              targetBodyWeight: targetBodyWeight,
                              hoursSleep: hoursSleep,
                              daysExercise: daysExercise,
                              maintenanceCalories: maintenanceCalories,

                              //Checkbox variables pushed to Firebase
                              breakfast: breakfast,
                              american: american,
                              italian: italian,
                              mexican: mexican,
                              chinese: chinese,

                              //Dropdown String variables pushed to Firebase
                              loseWeight: loseWeight,
                              gainWeight: gainWeight,
                              maintainWeight: maintainWeight,
                              selectedGender: gender,
                              selectedDay: day,
                              selectedJobActivity: jobActivity);

                          // await insert profile data here
                          final result = _auth.registerEmailAndPassword(
                              email, password, user, weight);
                          Future.delayed(const Duration(seconds: 2), () {
                            result.then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  PageTransition(
                                      widget: HomePageScreen(
                                    homeScreenViewModel: HomeScreenViewModel(
                                        DatabaseService(), PrefsManager()),
                                  )),
                                  (se) => false);
                            }, onError: (error) {
                              // Display error
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())));
                              Navigator.of(context).pop();
                            });
                          });
                          // await _auth.signInWithEmailAndPassword(email, password);
                          // Navigator.push(context, PageTransition(widget: Homepage()));
                        }
                      }),
                  //Create case for noInput
                  const SizedBox(height: 14.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 12.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ];

  void onStepCancel() {
    final isFirstSteps = currentStep == 0;
    if(!isFirstSteps){
      setState(() => currentStep -= 1);
    }

  }

  void onStepContinue() {
    final isLastStep = currentStep == getSteps().length - 1;
    print(currentStep);
    if (isLastStep) {
      print('Completed');

      /// send data to server
    } else {
      if(currentStep == 3){
        int itemsSelected = 0;
        if(breakfast){
          itemsSelected++;
        }
        if(american){
          itemsSelected++;
        }
        if(italian){
          itemsSelected++;
        }
        if(mexican){
          itemsSelected++;
        }
        if(chinese){
          itemsSelected++;
        }
        if (itemsSelected >= 3){
          setState(() => currentStep += 1);
        }else{

        }
      }else{
        setState(() => currentStep += 1);
      }
    }
  }
}
