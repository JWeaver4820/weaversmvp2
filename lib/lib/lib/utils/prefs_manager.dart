import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager{

  static const String hasLaunchedKey ="_HAS_LAUNCHED";

  final Future<SharedPreferences> _prefs =  SharedPreferences.getInstance();

  void setHasLaunched(bool hasLaunched) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(hasLaunchedKey, hasLaunched);
  }

  Future<bool> getHasLaunched() async{
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(hasLaunchedKey) ?? true ;
  }

}