import 'dart:convert';
import 'dart:developer';

import 'package:parking/config.dart';
import 'package:parking/services/exceptions/HttpException.dart';
import 'package:http/http.dart' as http ;
class HttpSpotService {
  Future<bool> addSpot(String token, String zoneId) async
  {
    try {
      final response = await http.post(
        Uri.parse(myAPI().addSpotUrl),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
        body: json.encode({'zoneId':zoneId}),
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
  Future<String> getAll(String token, String zoneId) async
  {
    try {
      final response = await http.get(
        Uri.parse('${myAPI().getSpotsUrl}/$zoneId'),
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
  Future<bool> editName(String token, String zoneId,String zoneName) async
  {
    try {
      final response = await http.put(
        Uri.parse('${myAPI().editZoneNameUrl}/$zoneId'),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
        body: json.encode({'zoneName':zoneName}),
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
  Future<bool> deleteSpot(String token, String spotId) async
  {
    try {
      final response = await http.delete(
        Uri.parse('${myAPI().deleteSpotUrl}/$spotId'),
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
  Future<bool> clearSpot(String token, String spotId) async
  {
    try {
      final response = await http.put(
        Uri.parse('${myAPI().clearSpotUrl}/$spotId'),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 200)) {
        log("Failed to clear");
        throw HttpServiceException('Failed to clear');
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }
  Future<bool> updateSpot(String token, String spotId,String username) async
  {
    try {
      final response = await http.put(
        Uri.parse('${myAPI().updateSpotUrl}/$spotId'),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
        body: json.encode({'username':username})
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 200)) {
        log("Failed to clear");
        throw HttpServiceException('Failed to clear');
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }
  Future<bool> checkUser(String token, String username) async
  {
    try {
      final response = await http.get(
          Uri.parse('${myAPI().checkUserUrl}/$username'),
          headers: {"Content-Type": "application/json",
            "Authorization": token},
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode == 200)) {
        log("Failed to check");
        throw HttpServiceException('Failed to check');
      }
      return true;
    }
    catch (e) {
      return false;
    }
  }
}