import 'package:firebase_auth/firebase_auth.dart';
import 'package:weaversmvp/global_state.dart';
import 'package:weaversmvp/modeling/user.dart';
import 'package:weaversmvp/operations/database.dart';
import '../global_state.dart';

//Create class for authnetication
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  //Authentication, this is the stream for changing the user
  Stream<FBUser?> get userChange{

    return _auth.authStateChanges()
    .map(_firebaseUser);

  }
  
  //Create user FBUser object based on Firebase User (User)
  FBUser? _firebaseUser(User? user){

    if (user != null){
      return FBUser(uid: user.uid);
    } 
    else{
      return null;
    }

  }

  //Sign In with email and password
    Future signInWithEmailAndPassword(String email, String password) async{

    try{

      UserCredential credential =  await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = credential.user;
      GlobalState.set('user', user);
      return credential;

    }
    catch(e){
      return null;
    }

  }

  //Sign Up with email and password and instantiate default profile information
    Future registerEmailAndPassword(String email, String password) async{

    try{

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;  
      GlobalState.set('user', user);
      await DatabaseService().updateFBUserData(
        numDaysExercised: '1', 
        name: 'Name',
        weight: 'Weight',
        height: 'Height',
        targetBodyWeight: 'TBW',
        age: 18,
      );
      return _firebaseUser(user);
    }

    catch(e){
      return null;
    }

  }

  //Sign out of the application
  Future signOut() async{

    try{
      GlobalState.delete('user');
      return await _auth.signOut();
    }

    catch(e){
      return null;
    }

  }


}