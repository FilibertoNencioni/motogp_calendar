import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    DateFormat dayFormat = DateFormat('EEEE');

    return Column(
      children: [
        //BACK BUTTON (Always on top)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
              ),
            ]
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            )
          )
        ),
        SizedBox(height: 4,),
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
                    style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
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
    );
  }

}