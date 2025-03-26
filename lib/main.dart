import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/base/app_alert.dart';
import 'package:motogp_calendar/components/base/app_loader.dart';
import 'package:motogp_calendar/l10n/my_l10n.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:motogp_calendar/utils/constants.dart';
import 'package:motogp_calendar/utils/user_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:motogp_calendar/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  await UserPreferences.initUserPreferences();
  initializeDateFormatting();
  
  runApp(const MyApp());
}

///  Load current env from .env file
Future loadEnv() async {
  String envFile = kDebugMode ? ".env.dev" : ".env";
  await dotenv.load(fileName: envFile); 
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale appLocale = UserPreferences.getLocale().locale;

  @override
  Widget build(BuildContext context) =>
    MyL10n(
      (locale) => setState(() => appLocale = locale),
      child: MaterialApp.router(
        title: 'Moto Calendar',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        routerConfig: AppRouter.router,
        supportedLocales: appLocales.map((e)=>e.locale),
        locale: appLocale,
        localizationsDelegates: [
          AppLocalizations.delegate, //TODO: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#localizing-for-ios-updating-the-ios-app-bundle
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) => Stack(
          children: [
            //PAGE CONTENT
            child ?? Container(),

            //APP LOADING
            Align(
              alignment: Alignment.center,
              child: AppLoader()
            ),
            
            //APP ALERT
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 28
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AppAlert(),
              )
            ),
          ],
        )
      )
    );

}