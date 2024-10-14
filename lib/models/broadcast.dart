class BroadCast{
  String id;
  String shortName;
  String name;
  DateTime dateStart;
  DateTime dateEnd;
  String type;
  String kind;
  String status;
  String category;

  BroadCast({
    required this.id,
    required this.shortName,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.kind,
    required this.status,
    required this.type,
    required this.category
  });

  factory BroadCast.fromJson(Map<String, dynamic> json) => BroadCast(
    id: json["id"],
    shortName: json["shortname"],
    name: json["name"],
    dateStart: DateTime.parse(json["date_start"]),
    dateEnd: DateTime.parse(json["date_end"]),
    type: json["type"],
    status: json["status"],
    kind: json["kind"],
    category: json["category"]["name"]
  );
}
