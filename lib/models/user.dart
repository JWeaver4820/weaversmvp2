import 'dart:core';

class User{
  
  int? weight; 
  int? height;
  int? targetBodyWeight;
  int? age;

  User({required this.age, required this.height,
   required this.targetBodyWeight, required this.weight});


  User.fromJson(Map<String, dynamic> json){
    weight = json['weight'];
    height = json['height'];
    targetBodyWeight = json['targetBodyWeight'];
    age = json['age'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json ={};
    json['weight'] = weight;
    json['height'] = height;
    json['targetBodyWeight'] = targetBodyWeight;
    json['age'] = age;
    return json;
  }

}