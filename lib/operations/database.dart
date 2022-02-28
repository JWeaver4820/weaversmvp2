import 'dart:convert';

import 'package:weaversmvp/modeling/daddy.dart';
import 'package:weaversmvp/modeling/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/models/user.dart';
import '../global_state.dart';

//Create the database class for managing the users profile information
class DatabaseService {

  get uid {

    return GlobalState.get('user')?.uid;

  }

  //This is the reference to the collection of data used within the application
  final CollectionReference dietData = FirebaseFirestore.instance.collection('diets');

  Future<void> updateFBUserData(uid, {required model.User user}) async {

    return await dietData.doc(uid).set(user.toJson());

  }

  Stream<User> getUser(String? uid){


    return  dietData.doc(uid).snapshots().map((event){
    
      final data = jsonEncode(event.data());
      return  User.fromJson(Map.from(jsonDecode(data)));
    });
  }

  //Get the list of profiles from the snapshot
  List<DietDaddy> _dietDataFromSnapshot(DocumentSnapshot<dynamic> snapshot) {

      return [

        DietDaddy(

          name: snapshot.data()['name'] ?? '',
          numDaysExercised: snapshot.data()['numDaysExercised'] ?? '0',
          weight: snapshot.data()['weight'] ?? '',
          height: snapshot.data()['height'] ?? '',
          targetBodyWeight: snapshot.data()['targetBodyWeight'] ?? '',
          age: snapshot.data()['age'],

        )

      ].toList();

  }

  //Get the users data from the snapshots
  FBUserData _FBuserDataFromSnapshot(DocumentSnapshot<dynamic> snapshot) {

    return FBUserData(

      uid: uid,
      name: snapshot.data()!['name'],
      numDaysExercised: snapshot.data()!['numDaysExercised'],
      weight: snapshot.data()!['weight'],
      height: snapshot.data()!['height'],
      targetBodyWeight: snapshot.data()!['targetBodyWeight'],
      age: snapshot.data()!['age'],

    );

  }

  //Get the stream for the diets / profiles
  
  Stream<List<DietDaddy>> get diets {

    if (uid == null) return Stream.empty();
    return dietData.doc(uid).snapshots().map(_dietDataFromSnapshot);

  }


  //Get the stream for the users data
  Stream<FBUserData> get userData {

    if (uid == null) return Stream.empty();
    return dietData.doc(uid).snapshots().map(_FBuserDataFromSnapshot);

  }

}