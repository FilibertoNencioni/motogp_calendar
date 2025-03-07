import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motogp_calendar/l10n/my_l10n.dart';
import 'package:motogp_calendar/models/broadcaster.dart';
import 'package:motogp_calendar/utils/constants.dart';
import 'package:motogp_calendar/utils/types/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static late SharedPreferences _userPref; 

  //KEYS
  static const String keyLocale = "user_locale";
  static const String keyBroadcaster = "user_default_broadcaster";
  static const String keyDismissedEvents = "user_dismissed_events";

  //VALUES
  static final ValueNotifier<Broadcaster?> userBroadcaster = ValueNotifier(null);
  static final ValueNotifier<bool?> userGetDismissed = ValueNotifier(false);

  static Future initUserPreferences() async {
    _userPref = await SharedPreferences.getInstance();
  }

  
  ///Return the user locale from his preferences
  static AppLocale getLocale(){
    String? localeCode = _userPref.getString(keyLocale);
    //If it was already setted, return the app locale 
    if(localeCode != null){
      return appLocales.firstWhere((e)=>e.code == localeCode);
    }

    //First time the app is opened!
    //Check if the system locale exists in the app supported ones
    //and set it as default
    String sysLocaleName = Platform.localeName;
    String sysLocaleCode = sysLocaleName.contains("_") ? sysLocaleName.split("_").first : sysLocaleName;

    AppLocale locale = appLocales.firstWhere(
      (l)=>l.code == sysLocaleCode,
      orElse: ()=> appLocales.first
    );

    setLocale(locale.code, null);
    return locale;
  }

  static void setLocale(String localeCode, BuildContext? context) {
    _userPref.setString(keyLocale, localeCode);

    if(context != null){
      MyL10n.of(context)!.changeLocale(Locale(localeCode));
    }
  }

  ///Get the user default broadcaster ID 
  static int getBroadcaster() =>
    _userPref.getInt(keyBroadcaster) ?? 1;

  static void setBroadcaster(Broadcaster broadcaster) {
    _userPref.setInt(keyBroadcaster, broadcaster.pkBroadcaster);
    userBroadcaster.value = broadcaster;
  }

  static bool getDismissedEvent() => 
    _userPref.getBool(UserPreferences.keyDismissedEvents) ?? false;
  
  static void setDismissedEvent(bool newValue){
    _userPref.setBool(UserPreferences.keyDismissedEvents, newValue);
    userGetDismissed.value = newValue;
  }

}