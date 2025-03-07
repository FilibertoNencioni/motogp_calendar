import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motogp_calendar/l10n/generated/app_localizations.dart';
import 'package:motogp_calendar/components/base/app_alert.dart';

class PageContainer extends StatelessWidget{
  final StatefulNavigationShell navigationShell;
  const PageContainer({super.key, required this.navigationShell});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          SafeArea(child: navigationShell),

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
          )
        ]
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int tappedIndex) => navigationShell.goBranch(tappedIndex),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: AppLocalizations.of(context)!.races
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings
            )
          ],
        ),
      )
    );
  }
}