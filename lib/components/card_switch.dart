import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/app_card.dart';

class CardSwitch extends StatefulWidget{
  /// Select label
  final String label;

  /// Selected value
  final bool value;

  /// Callback when the value changes
  final Function(bool)? onChanged;

  /// Info text (shown by an info icon after the switch title)
  final String? infoText;

  const CardSwitch({super.key, required this.label, required this.value, required this.onChanged, this.infoText});

  @override
  State<StatefulWidget> createState() => CardSwitchState();
}

class CardSwitchState extends State<CardSwitch>{
  @override
  Widget build(BuildContext context){
    return AppCard(
      padding: EdgeInsets.all(14),
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //LABEL
          Text(widget.label, style: Theme.of(context).textTheme.titleLarge),

          //INFO BTN (optional)
          if(widget.infoText != null)
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.info_outline,
                  size: 20,
                ),
                onPressed: () => showInfoText(),
              )
            ),

          Spacer(),

          //SWITCH
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: widget.value,
              onChanged: (value) => widget.onChanged!(value),
            ),
          )

        ],
      ),
    );
  }

  /// Open a dialog that contains the provided info text.
  /// This can be done only if infoText property is provided to the widget
  void showInfoText(){
    if(widget.infoText == null){
      return;
    }

    showAdaptiveDialog(
      context: context, 
      builder: (c) => Dialog(
        child: AppCard(
          padding: EdgeInsets.all(14),
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  //ICON
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.info_outline, size: 36, color: AppTheme.infoColor,),
                    ),
                  ),

                  //CONTENT
                  Text(widget.infoText!, style: Theme.of(context).textTheme.bodyMedium,),

                  //ACTIONS
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text("Ok"),
                        onPressed: () => c.pop(),
                      )
                    ],
                  )
                ],
              ) 
            ]
          )
        )
      )
    );
  }


}