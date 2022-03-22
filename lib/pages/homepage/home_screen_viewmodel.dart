import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/pages/auth/subpages/profile_viewmodel.dart';


class HomeScreenViewModel extends ProfileViewModel{

  DatabaseService? dbService;

  HomeScreenViewModel(this.dbService);

  final BehaviorSubject<model.User> _profile = BehaviorSubject();
  Stream<model.User> get profile => _profile.stream;

  

  final StreamController<model.User> _profileV2 = StreamController.broadcast();
  Stream<model.User> get profileV2 => _profileV2.stream;

  final BehaviorSubject<String> _logOut = BehaviorSubject();
  Stream<String> get logOut => _logOut.stream;


  void getUserData(){
     final source = dbService?.getUser(FirebaseAuth.instance.currentUser?.uid);
    if(source != null){
      source.listen((event) {
        
      print("object_object => $event");
      _profile.sink.add(event);
      }, onError: (erro){

        
      _profile.addError(erro);
      });
    }

  }

  void signOut(){
    FirebaseAuth.instance.signOut().then((value){
      _logOut.sink.add("You have been kicked out");
    } , onError: (error){
      _logOut.addError(error);
    }
    
    );
  }

  void dispose(){
    dbService = null;
    //_profile.close();
    _logOut.close();
  }
}