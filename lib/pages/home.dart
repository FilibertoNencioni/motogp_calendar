import 'package:flutter/material.dart';
import 'package:motogp_calendar/components/event_card.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/services/event.service.dart';
import 'package:motogp_calendar/utils/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:motogp_calendar/l10n/generated/app_localizations.dart';
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
    UserPreferences.userBroadcaster.addListener(() => getEvents());

    super.initState();
  }

  Future getEvents({bool showLoading = true}) async {
    List<Event> fetchedEvents =await EventService.get(
      DateTime.now().year.toString(),
      fkBroadcaster: UserPreferences.getBroadcaster(),
      getDismissed: UserPreferences.userGetDismissed.value ?? false,
      showLoading: showLoading
    );
    setState(() => events = fetchedEvents);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()=>getEvents(showLoading: false),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), //Required for pull to refresh
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //TITLE
            Text(
              AppLocalizations.of(context)!.races,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 32,),

            //LIST
            Column(
              spacing: 24,
              children: [
                ...events.map(
                  (e)=> EventCard(
                    event: e, 
                    onTap: () => handleRaceTap(e),
                    showLiveBadge: UserPreferences.getBroadcaster() != 1, //If is not official broadcaster
                  )
                )
              ],
            )
          ],
        ),
      )
    );
  }

  handleRaceTap(Event event) => context.push("/${AppRouter.routeEventDetail}", extra: event);
}