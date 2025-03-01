class Broadcaster {
  int pkBroadcaster;
  String name;
  String countryEmoji;
  DateTime doi;
  DateTime? dou;

  Broadcaster({
    required this.pkBroadcaster
    ,required this.name
    ,required this.countryEmoji
    ,required this.doi
    , this.dou
  });

  factory Broadcaster.fromJson(Map<String, dynamic> json) => Broadcaster(
    pkBroadcaster: json['pkBroadcaster'] as int,
    name: json['name'],
    countryEmoji: json['countryEmoji'],
    doi: DateTime.parse(json['doi']),
    dou: json['dou'] != null ? DateTime.parse(json['dou']) : null
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'pkBroadcaster': pkBroadcaster,
      'name': name,
      'countryEmoji': countryEmoji,
      'doi': doi.toIso8601String(),
      'dou': dou?.toIso8601String()
    };
    return data;
  }
}