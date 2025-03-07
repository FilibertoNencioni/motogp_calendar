import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/base/app_accordion.dart';
import 'package:motogp_calendar/components/base/app_accordion_list.dart';
import 'package:motogp_calendar/models/broadcast.dart';
import 'package:motogp_calendar/models/broadcaster.dart';
import 'package:motogp_calendar/models/category.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/services/broadcaster.service.dart';
import 'package:motogp_calendar/services/category.service.dart';
import 'package:motogp_calendar/services/event.service.dart';
import 'package:motogp_calendar/l10n/generated/app_localizations.dart';
import 'package:motogp_calendar/utils/user_preferences.dart';

class EventDetail extends StatefulWidget{
  final Event event;

  const EventDetail({super.key, required this.event});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  Map<DateTime, List<Broadcast>> groupedBroadcasts = {};
  List<Category> categories = [];
  Broadcaster? selectedBroadcaster;

  //TODO: enable change broadcaster in this page

  @override
  void initState() {
    super.initState();
    int selectedPkBroadcaster = UserPreferences.getBroadcaster();
    
    //GET DATA
    (
      _getBroadcasts(selectedPkBroadcaster),
      BroadcasterService.getByPk(selectedPkBroadcaster),
      CategoryService.get()
    ).wait.then((x) {
      if(mounted){
        setState(() {
          groupedBroadcasts = x.$1;
          selectedBroadcaster = x.$2;
          categories = x.$3;
        });
      }
    });


    //ADD LISTENER TO BROADCATSER CHANGE
    UserPreferences.userBroadcaster.addListener((){
      Broadcaster? newDefaultBroadcaster = UserPreferences.userBroadcaster.value;
      if(newDefaultBroadcaster != null){
        handleBroadcasterChange(newDefaultBroadcaster);
      }
    });

  }


  void handleBroadcasterChange(Broadcaster newBroadcaster) async {
    Map<DateTime, List<Broadcast>> tmpNewBroadcasts = await _getBroadcasts(newBroadcaster.pkBroadcaster);
    if(mounted){
      setState(() {
        groupedBroadcasts = tmpNewBroadcasts;
        selectedBroadcaster = newBroadcaster;
      });
    }
  }


  Future<Map<DateTime, List<Broadcast>>> _getBroadcasts(int fkBroadcaster) async {
    List<Broadcast> tmpBroadcasts = await EventService.getBroadcasts( 
      widget.event.pkEvent, 
      fkBroadcaster, 
    );
    Map<DateTime, List<Broadcast>> tmpGroupedBroadcasts = {};

    for(int i = 0; i< tmpBroadcasts.length; i++){
      DateTime currentDate = DateUtils.dateOnly(tmpBroadcasts[i].startDate);
      if(tmpGroupedBroadcasts.containsKey(currentDate)){
        tmpGroupedBroadcasts[currentDate]!.add(tmpBroadcasts[i]);
      }else{
        tmpGroupedBroadcasts[currentDate] = [tmpBroadcasts[i]];
      }
    }

    return tmpGroupedBroadcasts;
  }

  String _getCatName(int pkCategory) => categories.firstWhere((c)=>c.pkCategory == pkCategory).name;
  String _getBroadcasterName(Broadcaster b) => "${b.countryEmoji} ${b.name}";

  @override
  Widget build(BuildContext context) {
    DateFormat hourFormat = DateFormat("HH:mm");
    DateFormat dayFormat = DateFormat.EEEE(Localizations.localeOf(context).languageCode);

    return Scaffold(
      body: Column(
        children: [
          //BACK BUTTON (Always on top)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.chevron_left_rounded, size: 50,),
                  onPressed: () => context.pop(),
                ),
              ],
            )
          ),

          //LIST
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18),
              clipBehavior: Clip.hardEdge ,
              child: Column(
                children: [
                  //TITLE
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "${widget.event.name}, ${widget.event.circuit.country}",
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ),
                  SizedBox(height: 12,),


                  //PROVIDER SELEZIONATO
                  SizedBox(
                    width: double.infinity,
                    child: Text("${AppLocalizations.of(context)!.selectedBroadcaster}: ${selectedBroadcaster != null? _getBroadcasterName(selectedBroadcaster!) : ""}"),
                  ),
                  SizedBox(height: 12,),


                  //IMMAGINE
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: (widget.event.circuit.placeholderPath != null)?DecorationImage(
                        image: CachedNetworkImageProvider(widget.event.circuit.placeholderPath!),
                        fit:BoxFit.cover,
                      ): null,
                    ),
                  ),
                  SizedBox(height: 12,),

                  //LIST OF BROADCASTS
                  Visibility(
                    visible: groupedBroadcasts.isNotEmpty,
                    child: AppAccordionList(
                      items: groupedBroadcasts.entries.map<AppAccordion>((entry) => 
                        AppAccordion(
                          title: toBeginningOfSentenceCase(dayFormat.format(entry.key)),
                          child: Column(
                            spacing: 8,
                            children: entry.value.map((b)=>Row(
                              spacing: 12,
                              children: [
                               
                                //IS LIVE ICON
                                Visibility(
                                  visible: b.fkBroadcaster != 1,
                                  child: Row(
                                    spacing: 6,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: b.isLive? 
                                          AppTheme.dangerColor :
                                          AppTheme.appGrey,
                                        size: 8
                                      ),
                                      Text(
                                        b.isLive?
                                          AppLocalizations.of(context)!.live.toUpperCase() :
                                          AppLocalizations.of(context)!.delayed.toUpperCase(),
                                        style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                                      ),

                                    ],
                                  ) 
                                ),

                                //EVENT NAME
                                Expanded(
                                  child:Text.rich(
                                    TextSpan(
                                      children: [
                                        if(b.fkCategory != null)
                                          TextSpan(
                                            text: "${_getCatName(b.fkCategory!)} - ",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        TextSpan(text: b.name)
                                      ]
                                    ),                                      
                                  ),                                        
                                ),

                              

                                //EVENT HOUR
                                Text("${hourFormat.format(b.startDate)} ${b.endDate != null ? "- ${hourFormat.format(b.endDate!)}" : ""}")
                              ],
                            )).toList()
                          )
                        )
                      ).toList()
                      
                    )
                  )
                  
                ]
              )
            )
          )
        ]
      )
    );
  }
}