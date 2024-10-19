import 'package:flutter/material.dart';
import 'package:motogp_calendar/l10n/my_l10n.dart';
import 'package:motogp_calendar/utils/constants.dart';
import 'package:motogp_calendar/utils/types/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static late SharedPreferences _userPref; 

  static Future initUserPreferences() async {
    _userPref = await SharedPreferences.getInstance();
  }

  //KEYS
  static const String keyLocale = "user_locale";

  
  static AppLocale getLocale(){
    String localeCode = _userPref.getString(keyLocale) ?? "en";
    return appLocales.firstWhere((e)=>e.code == localeCode);
  }

  static void setLocale(String localeCode, BuildContext context) {
    _userPref.setString(keyLocale, localeCode);
    MyL10n.of(context)!.changeLocale(Locale(localeCode));
  }

}