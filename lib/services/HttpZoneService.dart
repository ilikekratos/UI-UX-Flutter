


import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:http/http.dart' as http ;
import 'package:parking/config.dart';
import 'package:parking/services/exceptions/HttpException.dart';
class HttpZoneService {

  Future<String> getAll(String token, String lotId) async
  {
    try {
      final response = await http.get(
        Uri.parse('${myAPI().getZonesUrl}/$lotId'),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 200)) {
        log("Failed to get");
        throw HttpServiceException('Failed to get');
      }
      return response.body;
    }
    catch (e) {
      return e.toString();
    }
  }
  Future<bool> addZone(String token, String lotId,String zoneName) async
  {
    try {
      final response = await http.post(
        Uri.parse(myAPI().addZoneUrl),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
        body: json.encode({'lotId':lotId,'zoneName':zoneName}),
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 200)) {
        log("Failed to get");
        throw HttpServiceException('Failed to get');
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> deleteZone(String token, String zoneId) async
  {
    try {
      final response = await http.delete(
        Uri.parse('${myAPI().deleteZoneUrl}/$zoneId'),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 200)) {
        log("Failed to delete");
        throw HttpServiceException('Failed to delete');
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }
  Future<bool> editName(String token, String lotId,String lotName) async
  {
    try {
      final response = await http.put(
        Uri.parse('${myAPI().editLotNameUrl}/$lotId'),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
        body: json.encode({'lotName':lotName}),
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 201)) {
        log("Failed to update");
        throw HttpServiceException('Failed to update');
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }
}