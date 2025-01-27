import 'package:flutter/material.dart';
import 'package:motogp_calendar/models/circuit.dart';
import 'package:motogp_calendar/utils/enum/e_event_status.dart';

class Event{
  int pkEvent;
  int fkCircuit;
  String guid;
  String name;
  String kind;
  String season;
  DateTime startDate;
  DateTime endDate;
  DateTime doi;
  DateTime? dou;
  Circuit circuit;

  Event({
    required this.pkEvent,
    required this.fkCircuit,
    required this.guid,
    required this.name,
    required this.kind,
    required this.season,
    required this.startDate,
    required this.endDate,
    required this.doi,
    this.dou,
    required this.circuit
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    pkEvent: json["pkEvent"],
    fkCircuit: json["fkCircuit"],
    guid: json["guid"],
    name: json["name"],
    kind: json["kind"],
    season: json["season"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    doi: DateTime.parse(json["doi"]),
    dou: json["dou"] != null ? DateTime.parse(json["dou"]) : null,
    circuit: Circuit.fromJson(json["circuit"])
  );

  
  ///Metodo che ritorna lo stato di un evento. (non considero il tempo, solo la data)
  ///1 = non iniziato (futura)
  ///2 = è in corso
  ///3 = è finito
  EEventStatus getEventStatus(){
    DateTime now = DateTime.now();

    if(DateUtils.isSameDay(endDate, startDate)){
      //Evento giornaliero
      if(DateUtils.isSameDay(now, startDate)){
        return EEventStatus.inProgress;
      }else if(now.isAfter(startDate)){
        return EEventStatus.finished;
      }else{
        DateTime firstDayOfRaceWeek = startDate.subtract(Duration(days: startDate.weekday - 1));
        if(DateUtils.isSameDay(now, firstDayOfRaceWeek) || now.isAfter(firstDayOfRaceWeek)){
          return EEventStatus.thisWeek;
        }else{
          return EEventStatus.notStarted;
        }
      }
    }else{
      //Evento NON giornaliero, controllo se oggi è compreso
      if(startDate.isBefore(now) && endDate.isAfter(now)){
        return EEventStatus.inProgress;
      }else if(now.isAfter(endDate)){
        return EEventStatus.finished;
      }else{
        DateTime firstDayOfRaceWeek = startDate.subtract(Duration(days: startDate.weekday - 1));
        if(DateUtils.isSameDay(now, firstDayOfRaceWeek) || now.isAfter(firstDayOfRaceWeek)){
          return EEventStatus.thisWeek;
        }else{
          return EEventStatus.notStarted;
        }
      }
    }
  }

}

