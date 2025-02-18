import 'package:flutter/material.dart';
import 'package:motogp_calendar/components/event_card.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/services/event.service.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:motogp_calendar/utils/user_preferences.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>{
  List<Event> events = [];

  @override
  void initState() {
    getEvents();

    //ADD LISTENER TO GET DISMISSED EVENTS CHANGE
    UserPreferences.userGetDismissed.addListener(() => getEvents());

    super.initState();
  }

  void getEvents(){
    EventService.get(
      DateTime.now().year.toString(),
      getDismissed: UserPreferences.userGetDismissed.value ?? false
    ).then((e) => setState(() => events = e));
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
                AppLocalizations.of(context)!.races,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
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

  handleRaceTap(Event event) => context.push("/${AppRouter.routeEventDetail}", extra: event);
}