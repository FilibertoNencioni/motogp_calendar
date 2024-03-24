import 'package:motogp_calendar/models/event.dart';
import 'package:motogp_calendar/utils/http.dart';

class MotoGpService{
  static const String baseUrl = "https://api.motogp.pulselive.com/motogp/v1";
  
  static Future<List<Event>> getEventsByYear(int year) async {
    List<Event> events = [];

    var eventsResponse = await Http.http.get<List>("$baseUrl/events?seasonYear=$year");
    
    if (eventsResponse.statusCode == 200) {
      events = eventsResponse.data!.map((e) => Event.fromJson((e as Map).cast())).toList();
    }

    return events;
  }
}