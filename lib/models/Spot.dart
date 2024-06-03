class Spot{
  final String id;
  final String zoneId;
  final String occupiedId;
  Spot({
    required this.id,
    required this.zoneId,
    required this.occupiedId,
  });
  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json["id"].toString(),
      zoneId: json["zoneId"].toString(),
      occupiedId:json["occupiedId"].toString(),
    );
  }
}