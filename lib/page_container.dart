import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageContainer extends StatelessWidget{
  final StatefulNavigationShell navigationShell;

  const PageContainer({super.key, required this.navigationShell});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: navigationShell),
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
              label: 'Gare'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Impostazioni'
            )
          ],
        ),
      )
    );
  }
}