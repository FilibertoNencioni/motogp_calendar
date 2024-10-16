import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getTheme() {
    ThemeData theme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Color.fromARGB(255, 138, 137, 137),
        type: BottomNavigationBarType.fixed,
        
      )
    );

    return theme.copyWith(textTheme: GoogleFonts.latoTextTheme(theme.textTheme),);
  } 

}