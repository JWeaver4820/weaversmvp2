import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:moving_average/moving_average.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:weaversmvp/utils/prefs_manager.dart';
import '../../operations/database.dart';


class WeightViewModel{


  Timer? scheduler;

  late PrefsManager prefsManager;

  WeightViewModel({required this.prefsManager});

  BehaviorSubject<String> _updateWeight = BehaviorSubject<String>() ;
  Stream<String> get updateWeight => _updateWeight.stream;

 // bool hasLaunched = false;

  void runTask() async{

  }

  void onStart(){
    print("RUNNING IN THE BACKGROUND...");
  }

  void onIOSBackground(){
    WidgetsFlutterBinding.ensureInitialized();
    print("RUNNING IN THE BACKGROUND.._.");

    final service = FlutterBackgroundService();
    service.onDataReceived.listen((event) { 
        /*if(event!["action"] == "setAsForeground"){
          service.setAsForegroundService();
          return;
        }*/
    });
  }
//update hi
  void updateWeights(int weightValue) async{
    final timestamp = FieldValue.serverTimestamp();

    final myPushId = DateTime.now().millisecond;
    try{
       await DatabaseService().updateWeight(Weight(weightKey: "_$myPushId", weightValue: weightValue, createdAt: timestamp ) );
    _updateWeight.sink.add("Weight updated!!");
       prefsManager.setHasLaunched(true);

    }catch(exception){
      _updateWeight.sink.addError(exception);
    }
  }


  void dispose(){
    _updateWeight.close();
   // _launchWeight.close();
  }
}