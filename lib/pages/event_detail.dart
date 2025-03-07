import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/base/app_accordion.dart';
import 'package:motogp_calendar/components/base/app_accordion_list.dart';
import 'package:motogp_calendar/components/base/app_cached_image.dart';
import 'package:motogp_calendar/components/base/app_card.dart';
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

  ///List of all broadcasters
  List<Broadcaster> broadcasters = [];
  
  Broadcaster? selectedBroadcaster;

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
                crossAxisAlignment: CrossAxisAlignment.start,
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


                  //SELECTED PROVIDER
                  OutlinedButton(
                    onPressed: ()=>handleChangeBroadcasterTap(), 
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: AppLocalizations.of(context)!.changeBroadcaster),
                          TextSpan(
                            text: " (${selectedBroadcaster?.name ?? ""} ${selectedBroadcaster?.countryEmoji ?? ""})", 
                            style: TextStyle(fontWeight: FontWeight.bold)
                          ),
                        ]
                      )
                    )
                  ),
                  SizedBox(height: 12,),


                  //IMAGE
                  AppCachedImage(
                    url: widget.event.circuit.placeholderPath,
                    height: 200,
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


  void handleChangeBroadcasterTap() async {
    if(broadcasters.isEmpty){
      List<Broadcaster> tmpBroadcasters = await BroadcasterService.get();
      setState(()=>broadcasters = tmpBroadcasters);
    }

    List<Broadcaster> availableBroadcasters = broadcasters
        .where((x)=>x.pkBroadcaster != (selectedBroadcaster?.pkBroadcaster ?? 0))
        .toList();

    if(mounted){
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
                    //Title
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          AppLocalizations.of(context)!.selectBroadcaster,
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ),
                    ),

                    //CONTENT
                    ListView.separated(
                      clipBehavior: Clip.none,
                      shrinkWrap: true,
                      itemCount: availableBroadcasters.length,
                      separatorBuilder: (c, i)=> SizedBox(height: 4,), 
                      itemBuilder: (c, i)=>
                        TextButton(
                          style: Theme.of(context).textButtonTheme.style?.copyWith(padding: WidgetStateProperty.all(EdgeInsets.zero)),
                          child: Text("${availableBroadcasters[i].countryEmoji} ${availableBroadcasters[i].name}", style: Theme.of(context).textTheme.bodyLarge),
                          onPressed: () {
                            handleBroadcasterChange(availableBroadcasters[i]);
                            context.pop();
                          },
                        ),
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
}