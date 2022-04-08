import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';

//Create class for authentication
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  final fbDb = DatabaseService();

  //Sign In with email and password
  void signInWithEmailAndPassword(
      String email, String password, Function(model.User?) status) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    final user = credential.user;
    if (user != null) {
      fbDb.getUser(user.uid).listen((event) {
        status.call(event);
      }, onError: (error) {
        print("MYERROR -> $error");
        status.call(null);
      });
    } else {
      status.call(null);
    }
  }

  //Sign Up with email and password and instantiate default profile information
  Future<String> registerEmailAndPassword(
      String email, String password, model.User user, int? weight) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User currentUser = result.user!;
      fbDb.addUser(currentUser.uid,
          user: user,
          weight: model.Weight(
              weightKey: "weightKey",
              weightValue: weight,
              id: "",
              createdAt: FieldValue.serverTimestamp()));

      return Future.value("Your sign up was successful!");
    } catch (error, trace) {
      print("registerEmailAndPassword => $trace");
      return Future.error(error);
    }
  }
}
