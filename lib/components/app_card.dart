import 'package:flutter/material.dart';

class AppCard extends StatelessWidget{
  final void Function()? onTap;
  final Widget child;

  ///Default padding is 10
  final EdgeInsets padding;

  const AppCard({
    super.key, 
    this.onTap, 
    required this.child, 
    this.padding = const EdgeInsets.all(10)
  });

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
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        padding: padding,
        child: child
      )
    );
  }

}