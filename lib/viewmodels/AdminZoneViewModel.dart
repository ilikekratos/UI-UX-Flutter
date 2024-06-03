import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:parking/models/Spot.dart';
import 'package:parking/services/HttpSpotService.dart';

class AdminZoneViewModel extends ChangeNotifier {
  String _jwtoken='';
  String _zoneName='error';
  String _zoneId = "-1";
  String _newZoneName='error';
  bool _isLoading=true;
  get isLoading =>_isLoading;
  List<Spot> spots = [];
  set zoneId(String value){
    _zoneId=value;
  }
  set jwtoken(String value){
    _jwtoken=value;
  }
  set newZoneName(String value){
    _newZoneName=value;
  }
  String get getNewZoneName => _newZoneName;
  set zoneName(String value){
    _zoneName=value;
  }

  String get getZoneName => _zoneName;
  final HttpSpotService httpService;
  AdminZoneViewModel({required this.httpService});
  void Function(String, String, String, String)? navigateCallback;

  void setNavigateCallback(
      void Function(String, String, String, String) callback) {
    navigateCallback = callback;
  }

  void triggerNavigate(String username, String jwtoken, String zoneId,
      String lotName) {
    if (navigateCallback != null) {
      navigateCallback!(username, jwtoken, zoneId, lotName);
    }
  }
  void getSpots()async
  {
    final responseString = await httpService.getAll(_jwtoken, _zoneId);
    List<dynamic> decoded = jsonDecode(responseString);
    spots = decoded.map((json) => Spot.fromJson(json)).toList();
    _isLoading = false;
    notifyListeners();
  }
  Future<bool> editName() async{
    bool response = await httpService.editName(_jwtoken,_zoneId,_newZoneName);
    return response;
  }
  Future<bool> addSpot() async{
    bool response = await httpService.addSpot(_jwtoken,_zoneId);
    getSpots();
    return response;
  }
  Future<bool> deleteSpot(String id) async{
    bool response=await httpService.deleteSpot(_jwtoken,id);
    getSpots();
    return response;
  }
  Future<bool> clearSpot(String id) async{
    bool response=await httpService.clearSpot(_jwtoken,id);
    getSpots();
    return response;
  }

}