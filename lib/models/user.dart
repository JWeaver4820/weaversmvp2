import 'dart:core';

class User{

  //admin fields
  late int currentStep = 0;
  String error = '';
  bool loading = false;
  String email = '';
  String password = '';

  //dropdown integer fields
  int? weight; 
  int? height;
  int? targetBodyWeight;
  int? age;
  int? hoursSleep;
  int? daysExercise;
  int? maintenanceCalories;

  //dropdown String fields
  String? loseWeight;
  String? gainWeight;
  String? maintainWeight;
  String? selectedJobActivity;
  String? selectedDay;
  String? selectedGender; 

  //checkbox boolean fields
  bool? breakfast;
  bool? american;
  bool? italian;
  bool? mexican;
  bool? chinese;

  User({ this.age, required this.height, required this.targetBodyWeight, this.gainWeight, required this.weight, 
          this.maintainWeight, this.loseWeight, this.american,  this.italian, this.mexican, this.chinese, this.breakfast, 
           required this.selectedGender, required this.selectedDay, required this.hoursSleep, required this.daysExercise,
            required this.selectedJobActivity, required this.maintenanceCalories});


  User.fromJson(Map<String, dynamic> json){
    weight = json['weight'];
    height = json['height'];
    targetBodyWeight = json['targetBodyWeight'];
    age = json['age'];
    loseWeight = json['loseWeight'];
    gainWeight = json['gainWeight'];
    maintainWeight = json['maintainWeight'];
    american = json['american'];
    italian = json['italian'];
    mexican = json['mexican'];
    chinese = json['chinese'];
    breakfast = json['breakfast'];
    selectedGender = json['selectedGender'];
    selectedDay = json['selectedDay'];
    hoursSleep = json['hoursSleep'];
    daysExercise = json['daysExercise'];
    selectedJobActivity = json['selectedJobActivity'];
    maintenanceCalories = json['maintenanceCalories'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json ={};
    json['weight'] = weight;
    json['height'] = height;
    json['targetBodyWeight'] = targetBodyWeight;
    json['age'] = age;
    json['loseWeight'] = loseWeight;
    json['gainWeight'] = gainWeight;
    json['maintainWeight'] = maintainWeight;
    json['american'] = american;
    json['italian'] = italian;
    json['mexican'] = mexican;
    json['chinese'] = chinese;
    json['breakfast'] = breakfast;
    json['selectedGender'] = selectedGender;
    json['selectedDay'] = selectedDay;
    json['hoursSleep'] = hoursSleep;
    json['daysExercise'] = daysExercise;
    json['selectedJobActivity'] = selectedJobActivity;
    json['maintenanceCalories'] = maintenanceCalories;
    return json;
  }

}