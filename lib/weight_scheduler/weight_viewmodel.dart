import 'dart:async';
import 'dart:ffi';

import 'package:cron/cron.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weaversmvp/models/user.dart';

import '../operations/database.dart';

class WeightViewModel{


  Timer? scheduler;

  BehaviorSubject<String> _launchWeight = BehaviorSubject<String>() ;
  Stream<String> get launchWeight => _launchWeight.stream;

  
  BehaviorSubject<String> _updateWeight = BehaviorSubject<String>() ;
  Stream<String> get updateWeight => _updateWeight.stream;

  bool hasLaunched = false;

  void runTask() async{
    print("Started task....");
   scheduler = Timer.periodic(const Duration(seconds: 20), (timer){{
     if(!hasLaunched){
       _launchWeight.sink.add("");
     }
     hasLaunched = true;
      
      }});


  }

  void updateWeights(int weightValue) async{
    final myPushId = DateTime.now().millisecond;
    await DatabaseService().updateWeight(Weight(weightKey: "_$myPushId", weightValue: weightValue) );
  }

  void dispose(){
    _updateWeight.close();
   // _launchWeight.close();
  }
}