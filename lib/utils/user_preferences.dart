import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static late SharedPreferences _userPref; 

  //KEYS

  static Future initUserPreferences() async {
    _userPref = await SharedPreferences.getInstance();
  }


}