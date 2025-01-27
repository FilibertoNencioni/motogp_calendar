class Circuit{
  int pkCircuit;
  String guid;
  String name;
  String country;
  String? flagPath;
  String? placeholderPath;
  DateTime? doi;
  DateTime? dou;

  Circuit({
    required this.pkCircuit,
    required this.guid,
    required this.name,
    required this.country,
    this.flagPath,
    this.placeholderPath,
    this.doi,
    this.dou
  });

  factory Circuit.fromJson(Map<String, dynamic> json) => Circuit(
    pkCircuit: json['pkCircuit'],
    guid: json['guid'],
    name: json['name'],
    country: json['country'],
    flagPath: json['flagPath'],
    placeholderPath: json['placeholderPath'],
    doi: json['doi'] != null ? DateTime.parse(json['doi']) : null,
    dou: json['dou'] != null ? DateTime.parse(json['dou']) : null,
  );
}