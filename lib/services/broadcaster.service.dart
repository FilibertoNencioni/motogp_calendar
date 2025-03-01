import 'package:motogp_calendar/models/broadcaster.dart';
import 'package:motogp_calendar/utils/http.dart';

class BroadcasterService{
  static Future<List<Broadcaster>> get() async {
    List<Broadcaster> brodcasters = [];

    var broadcastersResponse = await Http.serviceHttp.get<List>("/Broadcaster");
    
    if (broadcastersResponse.statusCode == 200) {
      brodcasters = broadcastersResponse.data!.map((e) => Broadcaster.fromJson((e as Map).cast())).toList();
    }

    return brodcasters;
  } 

  static Future<Broadcaster?> getByPk(int pkBroadcaster) async {
    var broadcastersResponse = await Http.serviceHttp.get("/Broadcaster/$pkBroadcaster");
    if(broadcastersResponse.statusCode == 200 && broadcastersResponse.data != null){
      return Broadcaster.fromJson(broadcastersResponse.data);
    }
    return null;
  }
}