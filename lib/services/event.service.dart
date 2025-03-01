import 'package:motogp_calendar/models/broadcast.dart';
import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/utils/http.dart';

class EventService{

  /// Get the events of [season]
  /// 
  /// [getDismissed] get the dismissed (canceled) events
  /// [fkBroadcaster] if specified it returns the "IS_LIVE" detail about the [fkBroadcaster]
  static Future<List<Event>> get(String season, {bool getDismissed = false, int? fkBroadcaster}) async {
    List<Event> events = [];
    
    Map<String, dynamic> params = {'season': season, 'getDismissed': getDismissed,};
    if(fkBroadcaster != null){
      params['fkBroadcaster'] = fkBroadcaster;
    }

    var eventsResponse = await Http.serviceHttp.get<List>(
      "/Event", 
      queryParameters: params
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