import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/app_card.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/utils/enum/e_event_status.dart';

class EventCard extends StatelessWidget{
  final Event event;
  final void Function() onTap;

  const EventCard({super.key, required this.event, required this.onTap});
  
  Color getEventStatusColor(EEventStatus eventStatus){
    switch(eventStatus){
      case EEventStatus.finished:
        return AppTheme.greenEStatus;
      case EEventStatus.inProgress:
      case EEventStatus.thisWeek:
        return AppTheme.orangeEStatus;
      case EEventStatus.notStarted:
        return AppTheme.greyEStatus;
    }
  }

  String getEventStatusText(EEventStatus eventStatus){
    switch(eventStatus){
      case EEventStatus.finished:
        return "Finished";
      case EEventStatus.inProgress:
        return "In progress";
      case EEventStatus.thisWeek:
        return "This week";
      case EEventStatus.notStarted:
        return "Not started";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat.yMd(Localizations.localeOf(context).languageCode);
    EEventStatus eventStatus = event.getEventStatus();

    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: (event.imageUrl != null)?
                DecorationImage(
                  image: CachedNetworkImageProvider(event.imageUrl!),
                  fit:BoxFit.cover
                ): 
                null,
            ),
          ),
          SizedBox(height: 8,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal:4),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //EVENT NAME
                  Text(
                    event.name, 
                    style: Theme.of(context).textTheme.titleLarge
                  ),
                  SizedBox(height: 6,),
                  Row(
                    children: [
                      //EVENT COUNTRY + DATES
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            //EVENT COUNTRY
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.location_pin, color: AppTheme.appGrey, size: 14,),
                                SizedBox(width: 8,),
                                Text(
                                  event.circuit!.country, 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppTheme.appGrey),
                                ),
                              ],
                            ),
                            SizedBox(height: 6,),

                            //EVENT DATES
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today, color: AppTheme.appGrey, size: 14,),
                                SizedBox(width: 8,),
                                Text(
                                  (event.dateEnd != null)?
                                    "${dateFormat.format(event.dateStart)} - ${dateFormat.format(event.dateEnd!)}" :
                                    dateFormat.format(event.dateStart), 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppTheme.appGrey),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),

                      //EVENT STATUS
                      Container(
                        decoration: BoxDecoration(
                          color: getEventStatusColor(eventStatus),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                          child: Text(
                            getEventStatusText(eventStatus),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)),
                        ),
                      )
                    ],
                  )
                ],
              )
            ),
          ),
        ],
      ),
    );
  }

  
}