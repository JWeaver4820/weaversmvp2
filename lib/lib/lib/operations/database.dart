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
  final CollectionReference dietData = FirebaseFirestore.instance.collection(
      'diets');

  Future<void> updateFBUserData(uid,
      {required model.User user, required model.Weight weight}) async {
    final weightResult = await dietData.doc(uid).collection("weights")
        .doc()
        .set(weight.toJson());
    return await dietData.doc(uid).set(user.toJson());
  }


  Future<void> updateWeight(model.Weight weight) async {
    final uId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return await dietData.doc(uId).collection("weights").doc().set(
        weight.toJson());
  }


  Future<List<model.Weight>> getWeights() async {
    final uId = FirebaseAuth.instance.currentUser?.uid ?? "";

    final result = await dietData.doc(uId).collection("weights").orderBy(
        "createdAt").get();
    print("__>${result.docs[0].data()}");
    return result.docs.map((e) => Weight.fromJson(e.data())).toList();
  }


  Stream<model.User> getUser(String? uid) async* {
    yield* dietData.doc(uid).snapshots().map((event) {
      final data = jsonEncode(event.data());
      final map = jsonDecode(data);
      print("objec-t ${model.User.fromJson(Map.from(map)).toJson()}");
      return model.User.fromJson(Map.from(map));
    });
  }
}