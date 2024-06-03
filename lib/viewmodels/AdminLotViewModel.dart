import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking/models/Zone.dart';
import 'package:parking/services/HttpZoneService.dart';

class AdminLotViewModel extends ChangeNotifier {
  final HttpZoneService httpService;
  bool _isLoading = true;
  String _jwtoken = '';
  List<Zone> zones = [];
  String _lotId = "-1";
  String _lotName = 'error';
  String _newLotName = '';
  get getJwtoken {
    return _jwtoken;
  }

  void Function(String, String, String)? navigateCallback;

  void setNavigateCallback(void Function(String, String, String) callback) {
    navigateCallback = callback;
  }

  void triggerNavigate(String jwtoken, String zoneId, String zoneName) {
    if (navigateCallback != null) {
      navigateCallback!(jwtoken, zoneId, zoneName);
    }
  }

  set newLotName(String value) {
    _newLotName = value;
  }

  get getNewLotName {
    return _newLotName;
  }

  set lotName(String value) {
    _lotName = value;
  }

  String get getLotName => _lotName;
  void updateLotName(String newLotName) {
    _lotName = newLotName;
    notifyListeners();
  }

  String _newZoneName = '';
  set newZoneName(String value) {
    _newZoneName = value;
  }

  get getNewZoneName {
    return _newZoneName;
  }

  AdminLotViewModel({required this.httpService});
  set jwtoken(String value) {
    _jwtoken = value;
  }

  set lotId(String value) {
    _lotId = value;
  }

  get isLoading {
    return _isLoading;
  }

  void reset() {
    _jwtoken = '';
    _lotName = 'error';
  }

  Future<void> getZones() async {
    final responseString = await httpService.getAll(_jwtoken, _lotId);
    log(responseString);
    List<dynamic> decoded = jsonDecode(responseString);
    zones = decoded.map((json) => Zone.fromJson(json)).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteZone(String id) async {
    bool response = await httpService.deleteZone(_jwtoken, id);
    await getZones();
    return response;
  }

  Future<bool> addZone() async {
    bool response = await httpService.addZone(_jwtoken, _lotId, _newZoneName);
    await getZones();
    return response;
  }

  Future<bool> editName() async {
    bool response = await httpService.editName(_jwtoken, _lotId, _newLotName);
    return response;
  }
}
