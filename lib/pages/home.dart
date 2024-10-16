import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motogp_calendar/components/event_card.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/services/motogp.service.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:go_router/go_router.dart';

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
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            //TITLE
            SizedBox(
              width: double.infinity,
              child: Text(
                "MotoGP Gare",
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
              ),
            ),
            SizedBox(height: 32,),

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
                  (index == events.length - 1) ? SizedBox() : SizedBox(height: 24,)
                ]
              )
            )
          ],
        ),
      )
    );
  }
  
  handleRaceTap(Event event){
    context.push("/${AppRouter.routeEventDetail}", extra: event);
  }
}