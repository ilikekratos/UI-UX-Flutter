
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:parking/models/Zone.dart';
import 'package:parking/services/HttpZoneService.dart';

class UserLotViewModel extends ChangeNotifier {
  final HttpZoneService httpService;
  UserLotViewModel({required this.httpService});
  String _jwtoken='';
  String _username='';
  String _lotId='-1';
  String _lotName='error';
  bool _isLoading = true;
  List<Zone> zones = [];
  get getUsername => _username;
  void Function(String, String, String,String)? navigateCallback;

  void setNavigateCallback(void Function(String, String, String,String) callback) {
    navigateCallback = callback;
  }

  void triggerNavigate(String username,String jwtoken, String zoneId, String zoneName) {
    if (navigateCallback != null) {
      navigateCallback!(username,jwtoken, zoneId, zoneName);
    }
  }
  get isLoading {
    return _isLoading;
  }
  get getJwtoken {
    return _jwtoken;
  }
  set username(String value){
    _username=value;
  }
  set jwtoken(String value){
    _jwtoken=value;
  }
  set lotId(String value){
    _lotId=value;
  }
  set lotName(String value){
    _lotName=value;
  }
  get getLotName => _lotName;
  Future<void> getZones() async {
    final responseString = await httpService.getAll(_jwtoken, _lotId);
    List<dynamic> decoded = jsonDecode(responseString);
    zones = decoded.map((json) => Zone.fromJson(json)).toList();
    _isLoading = false;
    notifyListeners();
  }

}