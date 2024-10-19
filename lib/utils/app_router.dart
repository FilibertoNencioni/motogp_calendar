import 'package:go_router/go_router.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/page_container.dart';
import 'package:motogp_calendar/pages/event_detail.dart';
import 'package:motogp_calendar/pages/home.dart';
import 'package:motogp_calendar/pages/settings.dart';

class AppRouter {
  
  static const String routeEvents = '/';
  static const String routeEventDetail = 'detail';
  static const String routeSettings = '/settings';

  static GoRouter router = GoRouter(
    initialLocation: routeEvents,
    routes:[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => PageContainer(navigationShell: navigationShell),
        branches: [
          //INDEX 1 (Events)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: routeEvents,
                builder: (context, state) => Home(),
                routes: [
                  GoRoute(
                    path: routeEventDetail,
                    builder: (context, state) => EventDetail(event: state.extra as Event)
                  )
                ]
              ),
            ]
          ),

          //INDEX 2 (Settings) 
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: routeSettings,
                builder: (context, state) => const Settings()
              )
            ]
          )
        ]
      )
    ]
  );
}