import '../utils/date_parser.dart';

class Broadcast{
  int pkBroadcast;
  int fkEvent;
  int fkBroadcaster;
  int? fkCategory;
  String? guid;
  String name;
  bool isLive;
  DateTime startDate;
  DateTime? endDate;
  DateTime doi;
  DateTime? dou;

  Broadcast({
    required this.pkBroadcast,
    required this.fkEvent,
    required this.fkBroadcaster,
    this.fkCategory,
    required this.guid,
    required this.name,
    required this.isLive,
    required this.startDate,
    this.endDate,
    required this.doi,
    this.dou
  });

  factory Broadcast.fromJson(Map<String, dynamic> json) => Broadcast(
    pkBroadcast: json['pkBroadcast'],
    fkEvent: json['fkEvent'],
    fkBroadcaster: json['fkBroadcaster'],
    fkCategory: json['fkCategory'],
    guid: json['guid'],
    name: json['name'],
    isLive: json['isLive'],
    startDate: DateParser.parseUTCDate(json['startDate']),
    endDate: json['endDate'] == null ? null : DateParser.parseUTCDate(json['endDate']),
    doi: DateParser.parseUTCDate(json['doi']),
    dou: json['dou'] == null ? null : DateParser.parseUTCDate(json['dou']),
  );
}
