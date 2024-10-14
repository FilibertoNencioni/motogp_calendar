import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/pages/home.dart';
import 'package:motogp_calendar/pages/settings.dart';
import 'package:motogp_calendar/styles/variables.dart';
import 'package:motogp_calendar/utils/http.dart';
import 'package:motogp_calendar/utils/user_preferences.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

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

  List<PersistentTabConfig> _tabs() => [
    PersistentTabConfig(
      screen: const Home(),
      item: ItemConfig(
        icon: const Icon(Icons.calendar_today),
        title: "Gare",
        activeColorSecondary: Color.fromARGB(122, 244, 67, 54),
        activeForegroundColor: Colors.black,
        iconSize: 22
      ),
    ),
    PersistentTabConfig(
      screen: Settings(),
      item: ItemConfig(
        icon: const Icon(Icons.sync),
        title: "Settings",
        activeColorSecondary: Color.fromARGB(122, 244, 67, 54),
        activeForegroundColor: Colors.black,
        iconSize: 22,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Locale defaultLocale = Locale(UserPreferences.getLocale());

    return MaterialApp(
      title: 'MotoGP Calendar',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: AppTheme.getTheme(),
      supportedLocales: [
        Locale('en'), // English
        Locale('it'), // Italian
      ],
      locale: defaultLocale,
      home: SafeArea(
        child: PersistentTabView(
          backgroundColor: backgroundColor, //TODO: migrate to theme
          tabs: _tabs(),
          navBarBuilder: (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
          ),
        ),
      )
    );
  }


}