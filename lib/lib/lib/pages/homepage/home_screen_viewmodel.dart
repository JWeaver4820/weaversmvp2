import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moving_average/moving_average.dart';
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

  final BehaviorSubject<num> _movingAvgDifferences = BehaviorSubject();
  Stream<num> get movingAvgDifferences => _movingAvgDifferences.stream;

  void promptForWeight() async{
    final hasLaunched = await _prefsManager.getHasLaunched();

    print("hasLaunched_hasLaunched => $hasLaunched");
    if(!hasLaunched){
      _launchWeight.sink.add("");
    }
  }


  void calculateMovingAverage(List<int> list) {
   // print("Values = $values");
    // Values = [1, 2, 3, 4, 5]
      //
    final simpleMovingAverage = MovingAverage<num>(
      averageType: AverageType.simple,
      windowSize: 8,
      partialStart: false,
      getValue: (num n) => n,
      add: (List<num> data, num value) => value,
    );

    if(list.isNotEmpty) {
      List<num> movingAverage3 = simpleMovingAverage(list);
      final List<num> movingAvgDifferences =[];
      print("Moving Average, size 3, partial = $movingAverage3");

      var start = movingAverage3.length -8;

      movingAverage3 = movingAverage3.sublist(start, movingAverage3.length );
      num len = movingAverage3.length -1;


      print("New Lenght = $len");

      for (var i =len; i >= 1; i--) {
        num left = movingAverage3[(i - 1).toInt()];
        num right = movingAverage3[i.toInt()];
        final result = (right -left);
        movingAvgDifferences.add(result);
      }

      print("Moving avg. differences => $movingAvgDifferences");
      num differencesAverage = movingAvgDifferences.fold(0, (previousValue, element) => previousValue + element) ;
      num result = differencesAverage / len;
      _movingAvgDifferences.sink.add(result);
      print("Moving avg. differences => $result");
    }


  }

  void getWeight(bool isAdded){
    DatabaseService().getWeights().then((value) {
      _weight.sink.add(value[value.length-1]);

      final weight = value[value.length-1];

      Timestamp timestamp = weight.createdAt;//;
      final weightDate = timestamp.toDate();
      final daysDiff =  DateTime.now().difference(weightDate);
      print("Time passed => ${daysDiff.inSeconds}");
      if(daysDiff.inSeconds >= 10){
        // launchPrompt.call();
        _prefsManager.setHasLaunched(false);
        if(isAdded){
          promptForWeight();
        }

        final list = value.map((e) => e.weightValue!).toList();
        calculateMovingAverage(list);

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