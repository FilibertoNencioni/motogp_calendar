import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motogp_calendar/components/event_card.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/pages/event_detail.dart';
import 'package:motogp_calendar/services/motogp.service.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
  List<Event> events = [];

  @override
  void initState() {

    MotoGpService.getEventsByYear(DateTime.now().year).then((e) {
      List<Event> tmpFilteredEvents = e.where((event)=>event.kind == "GP").toList();

      setState(() => events = tmpFilteredEvents);
    });
    super.initState();
  }

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
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "MotoGP Gare", 
                        style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),

                      )
                    ),
                  ),
                  //LIST
                  ListView.builder(
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: events.length,
                    itemBuilder: (context, index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        EventCard(event: events[index], onTap: () => handleRaceTap(events[index]),),
                        SizedBox(height: 24,)
                      ]
                    )
                  )
                ],
              )
            )
          )
        ],
      )
    );
  }


  void handleRaceTap(Event event){
    pushWithNavBar(
      context,
      MaterialPageRoute(builder: (context) => EventDetail(event: event,)),
    );
  }
}