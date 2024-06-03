import 'dart:developer';

class Zone{
  final String id;
  final String lotId;
  String zoneName;
  Zone({
    required this.id,
    required this.lotId,
    required this.zoneName,
  });
  factory Zone.fromJson(Map<String, dynamic> json) {
    return Zone(
      id: json["id"].toString(),
      lotId: json["lotId"].toString(),
      zoneName:json["zoneName"],
    );
  }
}