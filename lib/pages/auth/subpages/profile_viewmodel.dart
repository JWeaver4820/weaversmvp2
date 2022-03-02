import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';

class ProfileViewModel {

 //dropdown Integer options
 final BehaviorSubject<int> _height = BehaviorSubject();
 final BehaviorSubject<int> _weight = BehaviorSubject();
 final BehaviorSubject<int> _age = BehaviorSubject();
 final BehaviorSubject<int> _target = BehaviorSubject();
 final BehaviorSubject<int> _hoursSleep = BehaviorSubject();
 final BehaviorSubject<int> _daysExercise = BehaviorSubject();
 final BehaviorSubject<int> _maintenanceCalories = BehaviorSubject();

final  BehaviorSubject<String?> _updateProfile = BehaviorSubject();
 Stream<String?> get updateProfile => _updateProfile.stream;
 
 //Checkbox options
 final BehaviorSubject<bool> _breakfast = BehaviorSubject();
 final BehaviorSubject<bool> _american = BehaviorSubject();
 final BehaviorSubject<bool> _italian = BehaviorSubject();
 final BehaviorSubject<bool> _mexican = BehaviorSubject();
 final BehaviorSubject<bool> _chinese = BehaviorSubject();
 
 //dropdown String options
 final BehaviorSubject<String> _selectedJobActivity = BehaviorSubject();
 final BehaviorSubject<String> _selectedDay = BehaviorSubject();
 final BehaviorSubject<String> _selectedGender = BehaviorSubject();
  

  //dropdown integer options
  Stream<int> get heightStream => _height.stream;
  Stream<int> get weightStream => _weight.stream;
  Stream<int> get ageStream => _age.stream;
  Stream<int> get targetStream => _target.stream;
  Stream<int> get hoursSleep => _hoursSleep.stream;
  Stream<int> get daysExercise => _daysExercise.stream;
  Stream<int> get maintenanceCalories => _maintenanceCalories.stream;
  int? strHeight = 0, strWeight = 0, strAge = 0, strTarget = 0, strHoursSleep = 0, strDaysExercise = 0, strMaintenanceCalories = 0;
  
  //dropdown string options
/*   Stream<String> get gainWeight => _gainWeight.stream;
  Stream<String> get loseWeight => _loseWeight.stream;
  Stream<String> get maintainWeight => _maintainWeight.stream; */
  Stream<String> get selectedGender => _selectedGender.stream;
  Stream<String> get selectedJobActivity => _selectedJobActivity.stream;
  Stream<String> get selectedDay => _selectedDay.stream;
  String? strGender = "", strJobActivity = "", strSelectedDay = "";



  //checkbox boolean options
  Stream<bool> get breakfast => _breakfast.stream;
  Stream<bool> get american =>  _american.stream;
  Stream<bool> get italian => _italian.stream;
  Stream<bool> get mexican => _mexican.stream;
  Stream<bool> get chinese => _chinese.stream;
  bool? strBreakfast = false, strAmerican = false, strItalian = false, strMexican = false , strChinese = false;

  DatabaseService? databaseService = DatabaseService.instance;

  ProfileViewModel();

  void setDefaults(model.User? user){
    if(user ==  null)return;
    onAgeChanged(user.age);
    onHeightChanged(user.height);
    onTargetChanged(user.targetBodyWeight);
    onWeightChanged(user.weight);
    onHoursSleepChanged(user.hoursSleep);
    onMaintenanceCaloriesChanged(user.maintenanceCalories);
    onDaysExerciseChanged(user.daysExercise);
    onBreakfastChanged(user.breakfast);
    onChineseChanged(user.chinese);
    onAmericanChanged(user.american);
    onMexicanChanged(user.mexican);
    onItalianChanged(user.italian);
    onSelectedGenderChanged(user.selectedGender);
    onSelectedDayChanged(user.selectedDay);
    onSelectedJobActivityChanged(user.selectedJobActivity);


  }
  

  void onHeightChanged(int? height){
    _height.sink.add(height ?? 0);
    strHeight = height;
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

/*     void onLoseWeightChanged(String? loseWeight){
        this.loseWeight.text = loseWeight ?? "";
  }

    void setGainWeightChanged(String? gainWeight){
        this.gainWeight.text = gainWeight ?? "";
  }

    void onMaintainWeightChanged(String? maintainWeight){
         this.maintainWeight.text = maintainWeight ?? "";
         
  } */

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
  }

    void onSelectedJobActivityChanged(String? selectedJobActivity){
      if(selectedJobActivity == null)return;
    _selectedJobActivity.sink.add(selectedJobActivity );
  }

  void doUpdateProfile() async{
    _updateProfile.sink.add(null);
    final user = model.User(
    age: strAge, 
    height: strHeight, 
    weight: strWeight,
    targetBodyWeight: strTarget,
    hoursSleep: strHoursSleep, 
    daysExercise: strDaysExercise,
    maintenanceCalories: strMaintenanceCalories,
    loseWeight: "",
    gainWeight: "",
    maintainWeight: "", 
    breakfast: strBreakfast, 
    american: strAmerican,
    italian: strItalian,
    mexican: strMexican, 
    chinese: strChinese,
    selectedGender: strGender,
    selectedDay: strSelectedDay, 
    selectedJobActivity: strJobActivity);

     await DatabaseService().updateFBUserData(FirebaseAuth.instance.currentUser?.uid, 
     user: user );
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