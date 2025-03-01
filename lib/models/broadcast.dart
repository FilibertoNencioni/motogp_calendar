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
    startDate: DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    doi: DateTime.parse(json['doi']),
    dou: json['dou'] == null ? null : DateTime.parse(json['dou']),
  );
}
