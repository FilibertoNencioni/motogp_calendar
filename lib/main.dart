import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motogp_calendar/pages/home.dart';
import 'package:motogp_calendar/pages/sync.dart';
import 'package:motogp_calendar/styles/variables.dart';
import 'package:google_fonts/google_fonts.dart';
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
      screen: Sync(),
      item: ItemConfig(
        icon: const Icon(Icons.sync),
        title: "Sincronizza",
        activeColorSecondary: Color.fromARGB(122, 244, 67, 54),
        activeForegroundColor: Colors.black,
        iconSize: 22,

      ),
    ),
  ];



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoGP Calendar',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme:_buildTheme(),
      home: SafeArea(
        child: PersistentTabView(
          backgroundColor: backgroundColor,
          tabs: _tabs(),
          navBarBuilder: (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
          ),
        ),
      )
    );
  }

  ThemeData _buildTheme() {
  var baseTheme = ThemeData();

  return baseTheme.copyWith(
    textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
  );
}
}