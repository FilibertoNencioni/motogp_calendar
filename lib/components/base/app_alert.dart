import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/base/app_card.dart';
import 'package:motogp_calendar/services/alert.service.dart';
import 'package:motogp_calendar/utils/enum/e_alert_status.dart';
import 'package:motogp_calendar/utils/types/alert_options.dart';

class AppAlert extends StatefulWidget {

  const AppAlert({super.key});

  @override
  State<AppAlert> createState() => _AppAlertState();
}

class _AppAlertState extends State<AppAlert> {
  double _dragOffset = 0.0;
  int animationMs = 300;
  AlertOptions? alertOptions;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    //Allow change options on runtime
    AlertService().registerOnUpdate((option) {
      if(option != null){
        setState(() {
          alertOptions = option;
          _dragOffset = 0.0;
          _isVisible = true;
        });
      }else{
        setState(() { _isVisible = false;});
        Future.delayed(Duration(milliseconds: animationMs), () {
          alertOptions = option;
          _dragOffset = 0.0;
        });
      }
    });
  }


  Icon getIcon() {
    double iconSize = 38;

    switch (alertOptions?.status) {
      case EAlertStatus.success:
        return Icon(CupertinoIcons.checkmark_alt_circle_fill, color: AppTheme.successColor, size: iconSize);
      case EAlertStatus.error:
        return Icon(CupertinoIcons.xmark_circle_fill, color: AppTheme.dangerColor, size: iconSize);
      case EAlertStatus.info:
        return Icon(CupertinoIcons.info_circle_fill, color: AppTheme.infoColor, size: iconSize);
      case EAlertStatus.warning:
        return Icon(CupertinoIcons.exclamationmark_circle_fill, color: AppTheme.warningColor, size: iconSize);
      default:
        return Icon(CupertinoIcons.info_circle_fill, color: AppTheme.infoColor, size: iconSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        if (alertOptions != null) // Only show the alert when there are options
          AnimatedPositioned(
            duration: Duration(milliseconds: animationMs),
            curve: Curves.easeInOut,
            bottom: _isVisible ? 0 : -screenHeight * 0.3, // Slide down off-screen
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Update the position based on the user's drag
                setState(() {
                  _dragOffset += details.delta.dy;

                  // Ensure the user can only drag down
                  if (_dragOffset < 0) _dragOffset = 0;
                });
              },
              onVerticalDragEnd: (details) {
                // If dragged far enough down, dismiss the alert
                if (_dragOffset > 100) {
                  AlertService().hideAlert();
                } else {
                  // If not dragged far enough, return to the original position
                  setState(() {
                    _dragOffset = 0;
                  });
                }
              },
              child: Transform.translate(
                offset: Offset(0, _dragOffset), // Apply the drag offset
                child: getAlert(),
              ),
            ),
          ),
      ],
    );
  }
    
    
  Widget getAlert()=>
    AppCard(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                alertOptions!.title, 
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          ),
          getIcon(),
        ],
      ) 
    );
}