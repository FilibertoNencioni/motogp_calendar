import 'package:flutter/material.dart';
import 'package:motogp_calendar/components/select.dart';
import 'package:motogp_calendar/services/alert.service.dart';
import 'package:motogp_calendar/utils/constants.dart';
import 'package:motogp_calendar/utils/enum/e_alert_status.dart';
import 'package:motogp_calendar/utils/types/alert_options.dart';
import 'package:motogp_calendar/utils/types/app_locale.dart';
import 'package:motogp_calendar/utils/user_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();

}

class SettingsState extends State<Settings> {
  AppLocale selectedLocale = UserPreferences.getLocale();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            //TITLE
            SizedBox(
              width: double.infinity,
              child: Text(
                AppLocalizations.of(context)!.settings,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 32,),

            Select(
              label:AppLocalizations.of(context)!.changeAppLanguage,
              value: selectedLocale,
              displayItem: (t)=>t.displayName,
              items: appLocales,
              onChanged: handleLocaleSelect,
            )
 
          ]
        )
      )
    );
  }

  void handleLocaleSelect(AppLocale locale) {
    setState(()=>selectedLocale = locale);
    UserPreferences.setLocale(locale.code, context);
    
    //Delayed to show alert in the selected language
    Future.delayed(
      Duration(milliseconds: 100), 
      () {
        if(mounted){
          AlertService().showAlert(AlertOptions(status: EAlertStatus.success, title: AppLocalizations.of(context)!.languageChanged));
        }
      }
    );
    
  }
}