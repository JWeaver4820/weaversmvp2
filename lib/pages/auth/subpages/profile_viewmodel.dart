import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';

class ProfileViewModel {

  final BehaviorSubject<int> _height = BehaviorSubject();
  final BehaviorSubject<int> _weight = BehaviorSubject();
  final BehaviorSubject<int> _age = BehaviorSubject();
 final  BehaviorSubject<int> _targetStream = BehaviorSubject();
 
 final  BehaviorSubject<String?> _updateProfile = BehaviorSubject();
 Stream<String?> get updateProfile => _updateProfile.stream;

  
  Stream<int> get heigtStream => _height.stream;
  Stream<int> get weightStream => _weight.stream;
  Stream<int> get ageStream => _age.stream;
  Stream<int> get targetStream => _targetStream.stream;

  DatabaseService? databaseService = DatabaseService.instance;
  
  ProfileViewModel();


  void onHeightChanged(int? height){
    _height.sink.add(height ?? 0);
  }

  
  void onTargetChanged(int? weight){
    _targetStream.sink.add(weight ?? 0);
  }

  
  void onAgeChanged(int? age){
    _age.sink.add(age ?? 0);
  }

  
  void onWeightChanged(int? weight){
    _weight.sink.add(weight ?? 0);
  }

  void doUpdateProfile() async{
    _updateProfile.sink.add(null);
     Rx.combineLatest4(_age, _height, _weight, _targetStream, (a, b, c, d) => true).listen((event)async {
    
     await DatabaseService().updateFBUserData(FirebaseAuth.instance.currentUser?.uid, 
     user: model.User(age: _age.value, height: _height.value, weight: _weight.value, targetBodyWeight: _targetStream.value));
     _updateProfile.sink.add("Update successful");
     }, onError: (error){
        _updateProfile.addError(error);
     });

  }


  void dispose(){
    _height.close();
    _weight.close();
    _age.close();
    _targetStream.close();
    _updateProfile.close();
    databaseService =  null;
  }

    
}