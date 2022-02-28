import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';


class HomeScreenViewModel{

  DatabaseService? dbService;

  HomeScreenViewModel(this.dbService);

  final StreamController<model.User> _profile = StreamController();
  Stream<model.User> get profile => _profile.stream;




  void getUserData({String? uid }){
    final source = dbService?.getUser(FirebaseAuth.instance.currentUser?.uid);
    if(source != null){
   _profile.addStream(source);
    }

  }

  void dispose(){
    dbService = null;
    _profile.close();
  }
}