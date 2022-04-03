import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/pages/subpages/Profile/profile_viewmodel.dart';
import 'package:weaversmvp/utils/prefs_manager.dart';
import '../../models/user.dart';


class HomeScreenViewModel extends ProfileViewModel{

  DatabaseService? dbService;

  final PrefsManager _prefsManager;

  HomeScreenViewModel(this.dbService, this._prefsManager){
   promptForWeight();
  }

  final BehaviorSubject<model.User> _profile = BehaviorSubject();
  Stream<model.User> get profile => _profile.stream;


  final BehaviorSubject<Weight> _weight = BehaviorSubject();
  Stream<Weight> get weight => _weight.stream;


  BehaviorSubject<String> _launchWeight = BehaviorSubject<String>() ;
  Stream<String> get launchWeight => _launchWeight.stream;
  

  final StreamController<model.User> _profileV2 = StreamController.broadcast();
  Stream<model.User> get profileV2 => _profileV2.stream;

  final BehaviorSubject<String> _logOut = BehaviorSubject();
  Stream<String> get logOut => _logOut.stream;

  void promptForWeight() async{
    final hasLaunched = await _prefsManager.getHasLaunched();

    print("hasLaunched_hasLaunched => $hasLaunched");
    if(!hasLaunched){
      _launchWeight.sink.add("");
    }
  }

  void getWeight(bool isAdded){
    DatabaseService().getWeights().then((value) {
      _weight.sink.add(value[value.length-1]);

      final weight = value[value.length-1];

      Timestamp timestamp = weight.createdAt;//;
      final weightDate = timestamp.toDate();
      final daysDiff =  DateTime.now().difference(weightDate);
      print("Today is done => ${daysDiff.inMinutes}");
      if(daysDiff.inMinutes == 1){
        // launchPrompt.call();
        _prefsManager.setHasLaunched(false);
        if(isAdded){
          promptForWeight();
        }

        print("Today is done");
      }
    }, onError: (exception){
      _weight.addError(exception);
    });
  }

  void getUserData(){
     final source = dbService?.getUser(FirebaseAuth.instance.currentUser?.uid);
    if(source != null){
      source.listen((event) {
        
      print("object_object => $event");
      _profile.sink.add(event);
      }, onError: (error){
        
      _profile.addError(error);
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

  @override
  void dispose(){
    dbService = null;
  }
}