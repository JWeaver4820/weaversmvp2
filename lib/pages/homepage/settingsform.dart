import 'package:weaversmvp/modeling/user.dart';
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/sharing/load.dart';
import 'package:flutter/material.dart';

//Create the class for the profile settings / properties
class SettingsForm extends StatefulWidget {

  @override
  _SettingsFormState createState() => _SettingsFormState();

}

//Create the class for managing the states of the profile settings / properties
class _SettingsFormState extends State<SettingsForm> {

  //Settings needed
  final _needKey = GlobalKey<FormState>();
  final List<String> numDaysExercised = ['0', '1', '2', '3', '4', '5', '6', '7'];
  final List<int> age = [for(var i = 18; i <= 99; i++) i];

  // form values
  String? _currentName;
  String? _currentNumDaysExercised;
  int? _currentAge;
  String? _currentHeight;
  String? _currentWeight;
  String? _currentTBW;

  //Build the widget for updating the profile information in upper right after logging in
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<FBUserData>(
      stream: DatabaseService().userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          FBUserData? userData = snapshot.data;
          return SingleChildScrollView(child: Form(
            key: _needKey,
            child: Column(

              children: <Widget>[
                const Text(

                  'Update Your Diet Daddy Profile Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0),

                ),

                const SizedBox(height: 22.0),
                TextFormField(

                  initialValue: userData?.name,
                  validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
                  onChanged: (val) => setState(() => _currentName = val),

                ),

                const SizedBox(height: 12.0),
                DropdownButtonFormField<String>(

                  value: _currentNumDaysExercised ?? userData?.numDaysExercised,
                  items: numDaysExercised.map(

                    (dayExercised) {

                    return DropdownMenuItem(

                      value: dayExercised,
                      child: Text('$dayExercised days of exercise per week'),

                    );

                  }

                  ).toList(),

                  onChanged: (val) => setState(() => _currentNumDaysExercised = val as String),

                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<String>(
                  
                  value: _currentAge != null ? _currentAge.toString() : userData?.age.toString(),
                  items: age.map(
                    (item) {
                      return DropdownMenuItem(
                        value: item.toString(),
                        child: Text('$item age'),
                      );
                    }
                  ).toList(),

                  onChanged: (val) => setState(() => _currentAge = val as int),
                ),

                const SizedBox(height: 22.0),
                TextFormField(

                  initialValue: userData?.weight,
                  validator: (val) => val!.isEmpty ? 'Please enter weight' : null,
                  onChanged: (val) => setState(() => _currentWeight = val),

                ),
                //Height
                const SizedBox(height: 22.0),
                TextFormField(

                  initialValue: userData?.height,
                  validator: (val) => val!.isEmpty ? 'Please enter height' : null,
                  onChanged: (val) => setState(() => _currentHeight = val),

                ),
                //Target Body Weight TBW
                const SizedBox(height: 22.0),
                TextFormField(

                  initialValue: userData?.targetBodyWeight,
                  validator: (val) => val!.isEmpty ? 'Please enter your TBW' : null,
                  onChanged: (val) => setState(() => _currentTBW = val),

                ),
                //Create box for updating
                const SizedBox(height: 13.0),

                //Create the button for updating the profile information
                ElevatedButton(
                style: ElevatedButton.styleFrom(

                //The color for the update profile information button  
                primary: Colors.teal[600], 

                //The color on click for update profile information button
                onPrimary: Colors.black,
                ),

                  child: Text(

                    'Update Profile',
                    style: TextStyle(color: Colors.teal[50]),

                  ),
                  //Properties changed and written to the database after pressing the update profile button
                  onPressed: () async {

                    if(_needKey.currentState!.validate()){

                      await DatabaseService().updateFBUserData(

                       numDaysExercised: _currentNumDaysExercised ?? snapshot.data?.numDaysExercised, 
                       name: _currentName ?? snapshot.data?.name, 
                       weight: _currentWeight ?? snapshot.data?.weight,
                       height: _currentHeight ?? snapshot.data?.height,
                       targetBodyWeight: _currentTBW ?? snapshot.data?.targetBodyWeight,
                       age:  _currentAge ?? snapshot.data?.age, 

                      );

                      Navigator.pop(context);

                    }

                  }
                ),
              ],

            ),
          ));
        } else {

          return Loading();

        }
      }
    );
  }
}