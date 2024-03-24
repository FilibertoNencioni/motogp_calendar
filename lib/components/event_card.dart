import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/styles/variables.dart';

class EventCard extends StatelessWidget{
  final Event event;
  final void Function() onTap;

  const EventCard({super.key, required this.event, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    int eventStatus = event.getEventStatus();

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          //CARD
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
                      
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: (event.imageUrl != null)?DecorationImage(
                        image: CachedNetworkImageProvider(event.imageUrl!),
                        fit:BoxFit.cover

                      ): null,
                    ),
                  ),
                  SizedBox(height: 8,),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (event.circuit != null) ?
                            "${event.name}, ${event.circuit!.country}" :
                            event.name, 
                          style: GoogleFonts.roboto(textStyle:TextStyle(fontWeight: FontWeight.w600, fontSize: 16))
                        ),
                        SizedBox(height: 6,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, color: grayColor, size: 14,),
                            SizedBox(width: 8,),
                            Text(
                              (event.dateEnd != null)?
                                "${dateFormat.format(event.dateStart)} - ${dateFormat.format(event.dateEnd!)}" :
                                dateFormat.format(event.dateStart), 
                              style: GoogleFonts.roboto(textStyle:TextStyle(fontSize: 12, color: grayColor)),
                            ),
                          ],
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
          ),

          //EVENT STATUS (onTop)
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.circle, 
                size: 10, 
                color: (eventStatus == 1) ?
                  grayColor :
                  (eventStatus == 2) ?
                    Colors.orange :
                    Colors.green
              )
            )
          ),
        ],
      )
    );
  }

  
}