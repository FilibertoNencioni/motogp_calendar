import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();

}

class SettingsState extends State<Settings> {
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
                "Settings",
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
              ),
            ),
            SizedBox(height: 32,),

            //TODO: gestire selezione locale
            //Gestire quindi anche l'i18n + update user preferences

            
            
          ]
        )
      )
    );
  }
}