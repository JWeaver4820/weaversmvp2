import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weaversmvp/models/user.dart';

class UserManager {


    static void saveUser(User user)async{
      
     final prefs =await SharedPreferences.getInstance();
     prefs.setString("user", jsonEncode(user));
    }

   static Future<User?> getUser() async{
      
     final prefs =await SharedPreferences.getInstance();
     final source =  prefs.getString("user");
     if(source == null){
       return null;
     }
     final decodedUser = jsonDecode(source);
     return decodedUser;
    }
}