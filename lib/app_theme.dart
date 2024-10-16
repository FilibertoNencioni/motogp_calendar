import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static Color appGrey = Color.fromARGB(255, 132, 132, 132);

  //EVENT STATUS COLORS
  static Color greenEStatus = Color.fromARGB(255, 76, 175, 80);
  static Color greyEStatus = appGrey;
  static Color orangeEStatus = Color.fromARGB(255, 252, 150, 1);
  
  static ThemeData getTheme() {
    ThemeData theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: appGrey,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        )
      )
    );

    return theme.copyWith(textTheme: GoogleFonts.robotoTextTheme(theme.textTheme),);
  } 

}