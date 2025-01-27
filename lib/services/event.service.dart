import 'package:motogp_calendar/models/broadcast.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/utils/http.dart';

class EventService{
  static Future<List<Event>> get(String season) async {
    List<Event> events = [];
    var eventsResponse = await Http.serviceHttp.get<List>(
      "/Event", 
      queryParameters: {'season': season}
    );
    
    if (eventsResponse.statusCode == 200) {
      events = eventsResponse.data!.map((e) => Event.fromJson((e as Map).cast())).toList();
    }

    return events;
  }

  static Future<List<Broadcast>> getBroadcasts(int pkEvent, int fkBroadcaster) async {    
    List<Broadcast> broadcasts = [];
    
    var broadcastsResponse = await Http.serviceHttp.get<List>(
      "/Event/$pkEvent/Broadcast", 
      queryParameters: {'fkBroadcaster': fkBroadcaster}
    );
    
    if (broadcastsResponse.statusCode == 200) {
      broadcasts = broadcastsResponse.data!.map((e) => Broadcast.fromJson((e as Map).cast())).toList();
    }

    return broadcasts;
  }
}