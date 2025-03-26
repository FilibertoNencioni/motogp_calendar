import 'package:flutter/material.dart';
import 'package:motogp_calendar/controllers/loader_controller.dart';

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    LoaderController().init(hide, show);
  }

  @override
  Widget build(BuildContext context) =>
    Visibility(
      visible: _isVisible,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        ),
        child: CircularProgressIndicator(
          strokeWidth: 4,
          strokeCap: StrokeCap.round,
        )
      ) 
    );

  void hide() => setState(() => _isVisible = false);
  void show() => setState(() => _isVisible = true);
}