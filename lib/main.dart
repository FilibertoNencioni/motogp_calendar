import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:motogp_calendar/utils/http.dart';
import 'package:motogp_calendar/utils/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.initUserPreferences();
  
  //Modifica dello spinner di caricamento
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.red
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.red
    ..textColor = Colors.black
    ..boxShadow = []
    ..dismissOnTap = false;

  Http.initHttp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Locale defaultLocale = Locale(UserPreferences.getLocale());

    return MaterialApp.router(
      title: 'MotoGP Calendar',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: AppTheme.getTheme(),
      routerConfig: AppRouter.router,
      supportedLocales: [
        Locale('en'), // English
        Locale('it'), // Italian
      ],
      locale: defaultLocale,
    );
  }


}