import 'package:flutter/material.dart';
import 'package:motogp_calendar/l10n/my_l10n.dart';
import 'package:motogp_calendar/models/broadcaster.dart';
import 'package:motogp_calendar/utils/constants.dart';
import 'package:motogp_calendar/utils/types/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static late SharedPreferences _userPref; 

  static Future initUserPreferences() async {
    _userPref = await SharedPreferences.getInstance();
  }

  static final ValueNotifier<Broadcaster?> defaultBroadcaster = ValueNotifier(null);


  //KEYS
  static const String keyLocale = "user_locale";
  static const String keyBroadcaster = "user_default_broadcaster";
  
  ///Return the user locale from his preferences
  static AppLocale getLocale(){
    String localeCode = _userPref.getString(keyLocale) ?? "en";
    return appLocales.firstWhere((e)=>e.code == localeCode);
  }

  static void setLocale(String localeCode, BuildContext context) {
    _userPref.setString(keyLocale, localeCode);
    MyL10n.of(context)!.changeLocale(Locale(localeCode));
  }

  ///Get the user default broadcaster ID 
  static int getBroadcaster(){
    int pkBroadcaster = int.parse(_userPref.getString(keyBroadcaster) ?? "1");
    return pkBroadcaster;
  }

  static void setBroadcaster(Broadcaster broadcaster) {
    _userPref.setString(keyBroadcaster, broadcaster.pkBroadcaster.toString());

    defaultBroadcaster.value = broadcaster;
  }
  

}