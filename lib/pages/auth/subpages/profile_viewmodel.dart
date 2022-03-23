import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';
import 'package:weaversmvp/weight_scheduler/weight_viewmodel.dart';

class ProfileViewModel extends WeightViewModel{

 //dropdown Integer options
 final BehaviorSubject<int> _height = BehaviorSubject();
 final BehaviorSubject<int> _weight = BehaviorSubject();
 final BehaviorSubject<int> _age = BehaviorSubject();
 final BehaviorSubject<int> _target = BehaviorSubject();
 final BehaviorSubject<int> _hoursSleep = BehaviorSubject();
 final BehaviorSubject<int> _daysExercise = BehaviorSubject();
 final BehaviorSubject<int> _maintenanceCalories = BehaviorSubject();
 
 //dropdown String options
 final BehaviorSubject<String> _selectedJobActivity = BehaviorSubject();
 final BehaviorSubject<String> _selectedDay = BehaviorSubject();
 final BehaviorSubject<String> _selectedGender = BehaviorSubject();
 final BehaviorSubject<String> _goals = BehaviorSubject();

 //Checkbox options
 final BehaviorSubject<bool> _breakfast = BehaviorSubject();
 final BehaviorSubject<bool> _american = BehaviorSubject();
 final BehaviorSubject<bool> _italian = BehaviorSubject();
 final BehaviorSubject<bool> _mexican = BehaviorSubject();
 final BehaviorSubject<bool> _chinese = BehaviorSubject();
  
  //Dropdown integer streams
  Stream<int> get heightStream => _height.stream;
  Stream<int> get weightStream => _weight.stream;
  Stream<int> get ageStream => _age.stream;
  Stream<int> get targetStream => _target.stream;
  Stream<int> get hoursSleepStream => _hoursSleep.stream;
  Stream<int> get daysExerciseStream => _daysExercise.stream;
  Stream<int> get maintenanceCaloriesStream => _maintenanceCalories.stream;
  //Initialize
  int? strHeight = 0, strWeight = 0, strAge = 0, strTarget = 0, strHoursSleep = 0, 
  strDaysExercise = 0, strMaintenanceCalories = 0;
  
  //Dropdown string streams
  Stream<String> get selectedGender => _selectedGender.stream;
  Stream<String> get selectedJobActivity => _selectedJobActivity.stream;
  Stream<String> get selectedDay => _selectedDay.stream;
  Stream<String> get goal => _goals.stream;
  //Initialize
  String? strGender = "", strJobActivity = "", strSelectedDay = "", strGoal;

  //Checkbox boolean streams
  Stream<bool> get breakfast => _breakfast.stream;
  Stream<bool> get american =>  _american.stream;
  Stream<bool> get italian => _italian.stream;
  Stream<bool> get mexican => _mexican.stream;
  Stream<bool> get chinese => _chinese.stream;
  //Initialize
  bool? strBreakfast = false, strAmerican = false, strItalian = false, strMexican = false , strChinese = false;

  //update profile
  final  BehaviorSubject<String?> _updateProfile = BehaviorSubject();
  Stream<String?> get updateProfile => _updateProfile.stream;

  DatabaseService? databaseService = DatabaseService.instance;

  ProfileViewModel();

  void setDefaults(model.User? user){
    if(user ==  null)return;
    //Integer variables changed
    onAgeChanged(user.age);
    onHeightChanged(user.height);
    onTargetChanged(user.targetBodyWeight);
   // onWeightChanged(user.weight);
    onHoursSleepChanged(user.hoursSleep);
    onMaintenanceCaloriesChanged(user.maintenanceCalories);
    onDaysExerciseChanged(user.daysExercise);

    //String variables changed
    onSelectedGenderChanged(user.selectedGender);
    onSelectedDayChanged(user.selectedDay);
    onSelectedJobActivityChanged(user.selectedJobActivity);

    //Checkbox variables changed
    onBreakfastChanged(user.breakfast);
    onChineseChanged(user.chinese);
    onAmericanChanged(user.american);
    onMexicanChanged(user.mexican);
    onItalianChanged(user.italian);

    //why cant this be above checkbox variables?
    String? goal;
    if(user.maintainWeight != null){
      goal = user.maintainWeight;
    }else if(user.loseWeight != null){
        goal = user.loseWeight;
    }else{
      goal = user.gainWeight;
    }
    onGoalChanged(goal);
    }
    List<String?> getGoalList(){
      return ["Goal: Lose Weight", "Goal: Gain Weight", "Goal: Maintain Weight"];
    }
  
  //str Changes NEEDS NOTATION
  void onHeightChanged(int? height){
    _height.sink.add(height ?? 0);
    strHeight = height;
  }

  void onGoalChanged(String? strGoal){
    _goals.sink.add(strGoal ?? "");
    this.strGoal = strGoal;
  }

  void onTargetChanged(int? targetWeight){
    _target.sink.add(targetWeight ?? 0);
    strTarget = targetWeight;
  }
  
  void onAgeChanged(int? age){
    _age.sink.add(age ?? 0);
    strAge = age;
  }
  
  void onWeightChanged(int? weight){
    _weight.sink.add(weight ?? 0);
    strWeight = weight;
  }

  void onHoursSleepChanged(int? hoursSleep){
    _hoursSleep.sink.add(hoursSleep ?? 0);
    strHoursSleep = hoursSleep;
  }

  void onMaintenanceCaloriesChanged(int? maintenanceCalories){
    _maintenanceCalories.sink.add(maintenanceCalories ?? 0);
    strMaintenanceCalories = maintenanceCalories;
  }

  void onDaysExerciseChanged(int? daysExercise){
    _daysExercise.sink.add(daysExercise ?? 0);
    strDaysExercise = daysExercise;
  }

    void onBreakfastChanged(bool? breakfast){
         _breakfast.sink.add(breakfast ?? false); 
         strBreakfast = breakfast;
  }

      void onAmericanChanged(bool? american){
         _american.sink.add(american ?? false);
         strAmerican = american;
  }

      void onItalianChanged(bool? italian){
         _italian.sink.add(italian ?? false);
         strItalian = italian;
  } 

      void onMexicanChanged(bool? mexican){
         _mexican.sink.add(mexican ?? false);
         strMexican = mexican;
  } 

      void onChineseChanged(bool? chinese){
         _chinese.sink.add(chinese ?? false);
         strChinese = chinese;
  } 

    void onSelectedGenderChanged(String? selectedGender){
      if(selectedGender == null)return;
    _selectedGender.sink.add(selectedGender );
    strGender = selectedGender;
  }

  void onSelectedDayChanged(String? selectedDay){
      if(selectedDay == null)return;
    _selectedDay.sink.add(selectedDay );
    strSelectedDay = selectedDay;
  }

    void onSelectedJobActivityChanged(String? selectedJobActivity){
      if(selectedJobActivity == null)return;
    _selectedJobActivity.sink.add(selectedJobActivity );
    strJobActivity = selectedJobActivity;
  }

  //push profile update
  void doUpdateProfile() async{
    final loseWeight =  getGoalList()[0];
    final gainWeight =  getGoalList()[1];
    final maintainWeight =  getGoalList()[2];

    _updateProfile.sink.add(null);
    final user = model.User(
    age: strAge, 
    height: strHeight,
    targetBodyWeight: strTarget,
    hoursSleep: strHoursSleep, 
    daysExercise: strDaysExercise,
    maintenanceCalories: strMaintenanceCalories,
    
    loseWeight: strGoal == loseWeight ? loseWeight : null,
    gainWeight:  strGoal == gainWeight ? gainWeight : null,
    maintainWeight:  maintainWeight == strGoal ? maintainWeight : null, 

    breakfast: strBreakfast, 
    american: strAmerican,
    italian: strItalian,
    mexican: strMexican, 
    chinese: strChinese,
    selectedGender: strGender,
    selectedDay: strSelectedDay, 
    selectedJobActivity: strJobActivity);

     //update and display update message
     await DatabaseService().updateFBUserData(FirebaseAuth.instance.currentUser?.uid, 
     user: user, weight: model.Weight(weightKey: "weightKey", weightValue: strWeight, createdAt: FieldValue.serverTimestamp()) );
     print("myuser => ${user.toJson()} ");
     _updateProfile.sink.add("Update successful");

  }


  void dispose(){
    _height.close();
    _weight.close();
    _age.close();
    _target.close();
    _updateProfile.close();
    databaseService =  null;
  }

    
}