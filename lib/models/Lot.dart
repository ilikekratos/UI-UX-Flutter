import 'dart:developer';

class Lot{
  final String id;
  final String lotName;
  String latitude;
  String longitude;
  Lot({
    required this.id,
    required this.lotName,
    required this.latitude,
    required this.longitude,
  });
  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
        id:json["id"].toString(),
        lotName: json["lotName"],
        latitude:json["latitude"].toString(),
        longitude:json["longitude"].toString(),
    );
  }
}