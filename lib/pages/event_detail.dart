import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motogp_calendar/components/accordion.dart';
import 'package:motogp_calendar/components/accordion_list.dart';
import 'package:motogp_calendar/models/event.dart';

class EventDetail extends StatelessWidget{
  final Event event;

  const EventDetail({super.key, required this.event});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              clipBehavior: Clip.none ,
              child: Column(
                children: [
                  //TITLE
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Text(
                        (event.circuit != null)?
                          "${event.name}, ${event.circuit!.country}" :
                          event.name, 
                        style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),

                      )
                    ),
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
                  SizedBox(
                    width: double.infinity,
                    child: AccordionList(items: [
                      Accordion(
                        title: "Venerdì", 
                        child:Column(
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prove libere MotoGP"),
                                Text("18:00 - 19:00")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prove libere MotoGP"),
                                Text("18:00 - 19:00")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prove libere MotoGP"),
                                Text("18:00 - 19:00")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prove libere MotoGP"),
                                Text("18:00 - 19:00")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prove libere MotoGP"),
                                Text("18:00 - 19:00")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Prove libere MotoGP"),
                                Text("18:00 - 19:00")
                              ],
                            )
                          ],
                        )
                      ),
                      Accordion(title: "Sabato", child:SizedBox()),
                      Accordion(title: "Domenica", child:SizedBox()),

                    ],)
                    // ListView.builder(
                    //   clipBehavior: Clip.none,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: event.broadcasts.length,
                    //   itemBuilder: ((context, index) => ),
                    // ),
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