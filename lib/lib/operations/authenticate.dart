import 'package:firebase_auth/firebase_auth.dart';
import 'package:weaversmvp/global_state.dart';
import 'package:weaversmvp/modeling/user.dart';
import 'package:weaversmvp/models/user.dart' as model;
import 'package:weaversmvp/operations/database.dart';
import '../global_state.dart';

//Create class for authnetication
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  final fbDb = DatabaseService();

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
  //Sign In with email and password
    void signInWithEmailAndPassword(String email, String password, Function(model.User?) status) async{

   
    UserCredential credential =  await _auth.signInWithEmailAndPassword(email: email, password: password);

     final  user = credential.user;
      if(user != null){
      fbDb.getUser(user.uid).listen((event) {status.call(event);}, onError: (error){
        print("MYERROR -> $error");
        status.call(null);
      });

      
      }else{
        status.call(null);
      }
    }

  //Sign Up with email and password and instantiate default profile information
    Future<String> registerEmailAndPassword(String email, String password, model.User user) async{

    
     try{
        UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User currentUser = result.user!; 
      fbDb.updateFBUserData(currentUser.uid, user: user);
    
      return Future.value("Your sign up was successful!");
     }catch(error, trace){
       print("registerEmailAndPassword => $trace");
       return Future.error(error);
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