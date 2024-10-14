import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getTheme() {
    ThemeData theme = ThemeData(
      useMaterial3: true,
      // scaffoldBackgroundColor: Color.fromRGBO(255, 255, 255, 1)
    );

    return theme.copyWith(textTheme: GoogleFonts.latoTextTheme(theme.textTheme),);
  } 

}