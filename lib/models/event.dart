import 'package:flutter/material.dart';
import 'package:motogp_calendar/models/broadcast.dart';
import 'package:motogp_calendar/models/circuit.dart';

class Event{
  String id;
  String kind;
  String name;
  String? imageUrl;
  String? flagSvgUrl;
  String status;
  DateTime dateStart;
  DateTime? dateEnd;
  Circuit? circuit;
  List<BroadCast> broadcasts;

  Event({
    required this.id,
    required this.kind,
    required this.name,
    this.imageUrl,
    this.flagSvgUrl,
    required this.status,
    required this.dateStart,
    this.dateEnd,
    this.circuit,
    required this.broadcasts
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    kind: json["kind"],
    name: json["name"],
    imageUrl: _getImageFromType(json["assets"], "BACKGROUND"),
    flagSvgUrl: _getImageFromType(json["assets"], "FLAG"),
    status: json["status"],
    dateStart: DateTime.parse(json["date_start"]),
    dateEnd: (json["date_end"] != null) ? DateTime.parse(json["date_end"]) : null,
    circuit: (json["circuit"] != null)?Circuit.fromJson(json["circuit"]): null,
    broadcasts: List.from(json["broadcasts"].map((model)=> BroadCast.fromJson(model)))
  );

  
  static String? _getImageFromType(List<dynamic>json, String type){
    if(json.isNotEmpty){
      for (var element in json) {
        if(element["type"] == type) {

          //FIXME: fix temporaneo su immagine con 404 response code
          if(element["path"] == "https://photos.motogp.com/2024/events/background/SPA.png"){
            return "https://www.corsedimoto.com/wp-content/uploads/2019/04/09/08/30/spa.jpg";
          }
          return element["path"];
        }
      }
    }
    return null;
  }

  ///Metodo che ritorna lo stato di un evento. (non considero il tempo, solo la data)
  ///1 = non iniziato (futura)
  ///2 = è in corso
  ///3 = è finito
  int getEventStatus(){
    DateTime now = DateTime.now();

    if(dateEnd == null){
      //Evento giornaliero
      if(DateUtils.isSameDay(now, dateStart)){
        return 2;
      }else if(now.isBefore(dateStart)){
        return 1;
      }else{
        return 3;
      }
    }else{
      //Evento NON giornaliero, controllo se oggi è compreso
      if(dateStart.isBefore(now) && dateEnd!.isAfter(now)){
        return 2;
      }else if(dateStart.isAfter(now)){
        return 1;
      }else{
        return 3;
      }
    }
  }

  List<BroadcastsByDate> getBroadcastsByDate(){
    List<BroadcastsByDate> broadcastsByDate = [];

    for (var broadcast in broadcasts) {
      int indexOfBroadcast = broadcastsByDate.indexWhere((e) => DateUtils.isSameDay(e.date, broadcast.dateStart));
      if(indexOfBroadcast == -1){
        BroadcastsByDate newBroadcast = BroadcastsByDate(broadcasts: [broadcast], date: broadcast.dateStart);
        broadcastsByDate.add(newBroadcast);
      }else{
        broadcastsByDate[indexOfBroadcast].broadcasts.add(broadcast);
      }
    }

    return broadcastsByDate;
  }
}


//Service model
class BroadcastsByDate{
  List<BroadCast> broadcasts;
  DateTime date;

  BroadcastsByDate({
    required this.broadcasts,
    required this.date
  });
}