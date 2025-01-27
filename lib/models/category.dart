class Category {
  int pkCategory;
  String guid;
  String name;
  String acronym;
  DateTime doi;
  DateTime? dou;

  Category({
    required this.pkCategory
    ,required this.guid
    ,required this.name
    ,required this.acronym
    ,required this.doi
    , this.dou
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    pkCategory: json['pkCategory'] as int,
    guid: json['guid'],
    name: json['name'],
    acronym: json['acronym'],
    doi: DateTime.parse(json['doi']),
    dou: json['dou'] != null ? DateTime.parse(json['dou']) : null
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'pkBroadcaster': pkCategory,
      'guid': name,
      'name': name,
      'acronym': acronym,
      'doi': doi.toIso8601String(),
      'dou': dou?.toIso8601String()
    };
    return data;
  }
}