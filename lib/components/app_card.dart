import 'package:flutter/material.dart';

class AppCard extends StatelessWidget{
  final void Function()? onTap;
  final EdgeInsets? padding;
  final Widget child;

  const AppCard({super.key, this.onTap, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        padding: padding ?? EdgeInsets.all(10),
        child: child
      )
    );
  }

}