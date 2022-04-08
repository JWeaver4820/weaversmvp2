import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/models/user.dart';

//Create the database class for managing the users profile information
class DatabaseService {
  static final DatabaseService _INSTANCE = DatabaseService._internal();

  DatabaseService._internal();

  DatabaseService();

  static DatabaseService get instance => _INSTANCE;

  //This is the reference to the collection of data used within the application
  final CollectionReference dietData =
      FirebaseFirestore.instance.collection('diets');

  Future<void> addUser(uid,
      {required model.User user, String? key, required model.Weight weight}) async {
    //print("updated kin => ${weight.id}");
    await dietData
        .doc(uid)
        .collection("weights")
        .doc()
        .set(weight.toJson());
    return await dietData.doc(uid).set(user.toJson());
  }


  Future<void> updateFBUserData(uid,
      {required model.User user, String? key,
        model.Weight? weight}) async {

    return await dietData.doc(uid).update(user.toJson());
  }


  Future<void> updateMaintenanceCal(uid, {required num maintenanceCal}) async {

    return await dietData.doc(uid).update({"maintenanceCalories": maintenanceCal});
  }

  Future<void> updateWeight(model.Weight weight) async {
    final uId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return await dietData
        .doc(uId)
        .collection("weights")
        .doc()
        .set(weight.toJson());
  }

  Future<List<model.Weight>> getWeights() async {
    final uId = FirebaseAuth.instance.currentUser?.uid ?? "";

    final result = await dietData
        .doc(uId)
        .collection("weights")
        .orderBy("createdAt")
        .get();
    print("__>${result.docs[0].id}");
    return result.docs.map((e) {
      final weight = Weight.fromJson(e.data());
      weight.id = e.id;
     // print("weight.id => ${weight.id}");
      return weight;
    }).toList();
  }

  Stream<model.User> getUser(String? uid) async* {
    yield* dietData.doc(uid).snapshots().map((event) {
      final data = jsonEncode(event.data());
      final map = jsonDecode(data);
      return model.User.fromJson(Map.from(map));
    });
  }
}
