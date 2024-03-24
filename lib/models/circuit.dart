class Circuit{
  String id;
  String name;
  String country;

  Circuit({
    required this.id,
    required this.name,
    required this.country,
  });

  factory Circuit.fromJson(Map<String, dynamic> json) => Circuit(
    id: json["id"],
    name: json["name"],
    country: json["country"],
  );
}