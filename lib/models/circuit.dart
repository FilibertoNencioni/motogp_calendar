import 'package:motogp_calendar/utils/date_parser.dart';

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
    doi: json['doi'] != null ? DateParser.parseUTCDate(json['doi']) : null,
    dou: json['dou'] != null ? DateParser.parseUTCDate(json['dou']) : null,
  );
}