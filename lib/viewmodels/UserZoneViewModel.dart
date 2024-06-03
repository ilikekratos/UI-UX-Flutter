import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:parking/models/Spot.dart';
import 'package:parking/services/HttpSpotService.dart';

class UserZoneViewModel extends ChangeNotifier {
  final HttpSpotService httpService;
  UserZoneViewModel({required this.httpService});
  String _jwtoken='';
  String _zoneId='-1';
  String _zoneName='error';
  String _username='error';
  bool _isLoading=true;
  List<Spot> spots = [];
  set jwtoken(String value){
    _jwtoken=value;
  }
  set zoneId(String value){
    _zoneId=value;
  }
  set zoneName(String value){
    _zoneName=value;
  }
  set username(String value){
    _username=value;
  }
  get getZoneName =>_zoneName;
  void getSpots()async
  {
    final responseString = await httpService.getAll(_jwtoken, _zoneId);
    List<dynamic> decoded = jsonDecode(responseString);
    spots = decoded.map((json) => Spot.fromJson(json)).toList();
    spots.sort((a, b) => a.id.compareTo(b.id));
    _isLoading = false;
    notifyListeners();
  }
  get isLoading => _isLoading;

  Future<bool> updateSpot(String id) async{
    bool response = await httpService.updateSpot(_jwtoken, id,_username);
    getSpots();
    notifyListeners();
    return response;
  }
  Future<bool> checkUser()async{
    bool response=await httpService.checkUser(_jwtoken,_username);
    return response;
  }
}