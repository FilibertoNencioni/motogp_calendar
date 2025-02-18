import 'package:flutter/material.dart';
import 'package:motogp_calendar/components/card_switch.dart';
import 'package:motogp_calendar/components/select.dart';
import 'package:motogp_calendar/models/broadcaster.dart';
import 'package:motogp_calendar/services/alert.service.dart';
import 'package:motogp_calendar/services/broadcaster.service.dart';
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
  bool selectedGetDismissed = UserPreferences.getDismissedEvent();
  Broadcaster? selectedBroadcaster;

  List<Broadcaster> broadcasters = [];
  
  @override
  void initState(){
    super.initState();

    BroadcasterService.get().then((r) {
      int pkSelectedBroadcaster = UserPreferences.getBroadcaster();
      Broadcaster tmpSelectedBroadcaster = r.firstWhere((b)=>b.pkBroadcaster == pkSelectedBroadcaster);
      setState(() {
        broadcasters = r;
        selectedBroadcaster = tmpSelectedBroadcaster;
      });
    });
  }


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
            ),

            SizedBox(height: 32,),

            Select(
              label: AppLocalizations.of(context)!.changeDefaultBroadcasters,
              value: selectedBroadcaster,
              displayItem: (b)=>"${b?.countryEmoji} ${b?.name}",
              items: broadcasters,
              onChanged: handleBroadcasterSelect,
              infoText: AppLocalizations.of(context)!.broadcasterInfoText,
            ),

            SizedBox(height: 32,),

            CardSwitch(
              label: AppLocalizations.of(context)!.getDismissedEvent,
              value: selectedGetDismissed,
              onChanged: (e)=>handleChangeGetDismissed(e),
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

  void handleBroadcasterSelect(Broadcaster? broadcatser) {
    if(broadcatser == null) {
      return;
    }

    setState(()=>selectedBroadcaster = broadcatser);
    UserPreferences.setBroadcaster(broadcatser);    
    AlertService().showAlert(AlertOptions(
      status: EAlertStatus.success, 
      title: AppLocalizations.of(context)!.broadcasterChanged
    ));
  }

  void handleChangeGetDismissed(bool newValue) {
    setState(()=>selectedGetDismissed = newValue);
    UserPreferences.setDismissedEvent(newValue);    
    AlertService().showAlert(AlertOptions(
      status: EAlertStatus.success, 
      title: AppLocalizations.of(context)!.generalOptionChanged
    ));
  }
}