import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static late SharedPreferences _userPref; 

  static Future initUserPreferences() async {
    _userPref = await SharedPreferences.getInstance();
  }

  //KEYS
  static const String keyLocale = "user_locale";

  
  static String getLocale(){
    return _userPref.getString(keyLocale) ?? "en";
  }

  static void setLocale(String locale){
    _userPref.setString(keyLocale, locale);
  }

}