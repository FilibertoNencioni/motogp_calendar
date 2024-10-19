import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:motogp_calendar/components/accordion.dart';
import 'package:motogp_calendar/components/accordion_list.dart';
import 'package:motogp_calendar/models/event.dart';

class EventDetail extends StatelessWidget{
  final Event event;

  const EventDetail({super.key, required this.event});
  
  @override
  Widget build(BuildContext context) {
    List<BroadcastsByDate> broadcasts = event.getBroadcastsByDate();
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
                      (event.circuit != null)?
                        "${event.name}, ${event.circuit!.country}" :
                        event.name, 
                        style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ),
                  SizedBox(height: 8,),


                  //PROVIDER SELEZIONATO
                  SizedBox(
                    width: double.infinity,
                    child: Text("Provider selezionato: MotoGP Official"),
                  ),
                  SizedBox(height: 8,),


                  //IMMAGINE
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: (event.imageUrl != null)?DecorationImage(
                        image: CachedNetworkImageProvider(event.imageUrl!),
                        fit:BoxFit.cover

                      ): null,
                    ),
                  ),
                  SizedBox(height: 12,),

                  //LIST OF BROADCASTS
                  AccordionList(
                    items: broadcasts.map((e)=>Accordion(
                      title: dayFormat.format(e.date),
                      child: Column(
                        children: e.broadcasts.map((b)=>Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${b.category} ${b.name}"),
                            Text("${hourFormat.format(b.dateStart)} - ${hourFormat.format(b.dateEnd)}")
                          ],
                        )).toList(),
                      )
                    )).toList()
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