import 'dart:convert';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/models/Lot.dart';
import 'package:parking/services/HttpLotService.dart';
import 'package:parking/views/user_view.dart';

class UserViewModel extends ChangeNotifier {
  final HttpLotService httpService;
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  get customInfoWindowController {
    return _customInfoWindowController;
  }
  String _username = '';
  String _jwtoken = '';
  double currentLatitude = 0;
  double currentLongitude = 0;
  UserViewModel({required this.httpService}) {
    loadImage();
  }
  set jwtoken(String value) {
    _jwtoken = value;
  }
  set username(String value) {
    _username = value;
  }
  get getUsername => _username;
  get getJwtoken => _jwtoken;
  Uint8List? imageData;
  List<Lot> lots = [];
  void Function(String, String, String,String)? navigateCallback;

  void setNavigateCallback(void Function(String, String, String,String) callback) {
    navigateCallback = callback;
  }

  void triggerNavigate(String username, String jwtoken, String lotId, String lotName) {
    if (navigateCallback != null) {
      navigateCallback!(username, jwtoken, lotId,lotName);
    }
  }
  Future<Position> getPosition() async {
    await getLots();
    Position tempPosition = await Geolocator.getCurrentPosition();
    currentLatitude = tempPosition.latitude;
    currentLongitude = tempPosition.longitude;
    updateMarkers();
    return Geolocator.getCurrentPosition();
  }
  Future<void> getLots() async {
    final responseString = await httpService.getAll(_jwtoken);
    List<dynamic> decoded = jsonDecode(responseString);
    lots = decoded.map((json) => Lot.fromJson(json)).toList();
    notifyListeners();
  }
  Future<void> loadImage() async {
    ByteData data = await rootBundle.load("assets/PLogo.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 100);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? temp = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    if (temp != null) {
      imageData = temp.buffer.asUint8List();
    }
    notifyListeners();
  }
  Map<MarkerId, Marker> _markers = {};
  get markers {
    return _markers;
  }
  void updateMarkers() async{
    await getLots();
    _markers.clear();
    Marker marker = Marker(
        markerId: const MarkerId("mypos"),
        position: LatLng(currentLatitude, currentLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "You are here"),
        onTap: () => {
          _customInfoWindowController.hideInfoWindow!()
        });
    _markers[marker.markerId] = marker;
    for (var lot in lots) {
      if(!_markers.containsKey(MarkerId(lot.lotName))){
        LatLng location =
        LatLng(double.parse(lot.latitude), double.parse(lot.longitude));
        Marker marker = Marker(
            markerId: MarkerId(lot.lotName),
            position: location,
            icon: BitmapDescriptor.fromBytes(imageData!),
            onTap: () => {
              _customInfoWindowController.addInfoWindow!(
                UserMarker(
                  userViewModel: this,
                  lot: lot,
                ),
                location,
              )
            });
        _markers[marker.markerId] = marker;
      }
      else{
        for (var element in _markers.keys) {
          if(!lots.any((lot) => lot.lotName == element.value))
          {
            _markers.remove(element);
          }}
      }
    }
    notifyListeners();
  }
  void reset(){
    _username = '';
    _jwtoken = '';
  }

}