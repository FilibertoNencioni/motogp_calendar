import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  //OTHER COLORS
  static Color appGrey = Color.fromARGB(255, 132, 132, 132);

  static Color successColor = Color.fromARGB(255, 76, 175, 80);
  static Color dangerColor = Color.fromARGB(255, 240, 18, 20);
  static Color infoColor = Color.fromARGB(255, 62, 178, 186);
  static Color warningColor = Color.fromARGB(255, 252, 150, 1);

  //EVENT STATUS COLORS
  static Color greenEStatus = successColor;
  static Color greyEStatus = appGrey;
  static Color orangeEStatus = warningColor;
  


  static ThemeData getTheme() {
    ThemeData theme = ThemeData(
      useMaterial3: true,
      primaryColor: Colors.black,
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
      ),
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      textButtonTheme: TextButtonThemeData(
        
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
        )
      ),
      colorScheme: ColorScheme.light(
        error: dangerColor,
      ),
      switchTheme: SwitchThemeData(
        splashRadius: 0,

        //Circle color
        thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black;
        }),

        //Icon inside circle
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const Icon(Icons.check, color: Colors.black,);
          }
          return Icon(Icons.close, color: Colors.white);
        }),

        //Background color
        trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return Colors.white;
        }),

      )
    );

    return theme.copyWith(textTheme: GoogleFonts.robotoTextTheme(theme.textTheme),);
  } 

}