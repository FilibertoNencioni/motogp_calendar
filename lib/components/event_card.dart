import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motogp_calendar/app_theme.dart';
import 'package:motogp_calendar/components/app_card.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/utils/enum/e_event_status.dart';
import 'package:motogp_calendar/l10n/generated/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class EventCard extends StatelessWidget{
  final Event event;
  final void Function() onTap;

  /// If true it shows the "LIVE" badge
  final bool showLiveBadge;

  const EventCard({super.key, required this.event, required this.onTap, this.showLiveBadge = false});
  
  Color getEventStatusColor(EEventStatus eventStatus){
    switch(eventStatus){
      case EEventStatus.finished:
        return AppTheme.greenEStatus;
      case EEventStatus.inProgress:
      case EEventStatus.thisWeek:
        return AppTheme.orangeEStatus;
      case EEventStatus.notStarted:
        return AppTheme.greyEStatus;
      case EEventStatus.dismissed:
        return AppTheme.dangerColor;
    }
  }

  String getEventStatusText(EEventStatus eventStatus, BuildContext context){
    switch(eventStatus){
      case EEventStatus.finished:
        return AppLocalizations.of(context)!.finished;
      case EEventStatus.inProgress:
        return AppLocalizations.of(context)!.inProgress;
      case EEventStatus.thisWeek:
        return AppLocalizations.of(context)!.thisWeek;
      case EEventStatus.notStarted:
        return AppLocalizations.of(context)!.notStarted;
      case EEventStatus.dismissed:
        return AppLocalizations.of(context)!.canceled;
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
          Stack(
            alignment: Alignment.topRight,
            children: [

              //IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: event.circuit.placeholderPath != null ?
                  CachedNetworkImage(
                    imageUrl: event.circuit.placeholderPath!, 
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                    height: 130,
                    width: double.infinity,
                    placeholder: (c, url)=> Shimmer.fromColors(
                      baseColor: Colors.grey.shade300, 
                      highlightColor: AppTheme.appLightGrey,
                      child: imagePlaceholder(context, children: []), 
                    ),
                    errorWidget: (c, url, err)=> imagePlaceholder(
                      context, 
                      children: [
                        Icon(Icons.warning_rounded, color: AppTheme.appGrey),
                      ]
                    ),
                  ) :
                  imagePlaceholder(
                    context,
                    children: [
                      Icon(Icons.question_mark_rounded, color: AppTheme.appGrey),
                    ]
                  )
                  
              ),

              //LIVE INFO
              Visibility(
                visible: showLiveBadge && event.isLive != null && event.isLive == true,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle, 
                          color: AppTheme.dangerColor,
                          size: 8,
                        ),
                        SizedBox(width: 6,),
                        Text(
                          AppLocalizations.of(context)!.live.toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                        )

                      ],
                    ),
                  )
                )
              )
            ],
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
                                  event.circuit.country, 
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
                                  (!DateUtils.isSameDay(event.startDate, event.endDate))?
                                    "${dateFormat.format(event.startDate)} - ${dateFormat.format(event.endDate)}" :
                                    dateFormat.format(event.startDate), 
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
                            getEventStatusText(eventStatus, context),
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

  Widget imagePlaceholder(BuildContext context, {required List<Widget> children}) =>
    Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppTheme.appLightGrey
      ),
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children
      ),
    );

  
}