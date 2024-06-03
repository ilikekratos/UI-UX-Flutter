import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/models/Lot.dart';
import 'package:parking/services/HttpLotService.dart';
import 'package:parking/views/admin_view.dart';

class AdminViewModel extends ChangeNotifier {
  final HttpLotService httpService;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  String _username = '';
  String _jwtoken = '';
  String _newLotName = '';
  Uint8List? imageData;
  VoidCallback? showSuccessSnackbarCallback;
  VoidCallback? showFailureSnackbarCallback;
  void Function(LatLng)? showDialogCallback;
  VoidCallback? showErrorCallback;
  void setShowError(callback) {
    showErrorCallback = callback;
  }
  void triggerError() {
    if (showErrorCallback != null) {
      showErrorCallback!();
    }
  }
  void setShowDialogCallback(void Function(LatLng) callback) {
    showDialogCallback = callback;
  }
  void triggerDialog(LatLng tapped) {
    if (showDialogCallback != null) {
      showDialogCallback!(tapped);
    }
  }
  void Function(String, String, String,String)? navigateCallback;

  void setNavigateCallback(void Function(String, String, String,String) callback) {
    navigateCallback = callback;
  }

  void triggerNavigate(String username, String jwtoken, String lotId, String lotName) {
    if (navigateCallback != null) {
      navigateCallback!(username, jwtoken, lotId,lotName);
    }
  }


  void setSuccessSnackbarCallback(VoidCallback callback) {
    showSuccessSnackbarCallback = callback;
  }

  void setFailureSnackbarCallback(VoidCallback callback) {
    showFailureSnackbarCallback = callback;
  }

  void triggerSuccessSnackbar() {
    if (showSuccessSnackbarCallback != null) {
      showSuccessSnackbarCallback!();
    }
  }

  void triggerFailureSnackbar() {
    if (showFailureSnackbarCallback != null) {
      showFailureSnackbarCallback!();
    }
  }

  double currentLatitude = 0;
  double currentLongitude = 0;
  Map<MarkerId, Marker> _markers = {};
  List<Lot> lots = [];
  AdminViewModel({required this.httpService}) {
    loadImage();
  }
  get customInfoWindowController {
    return _customInfoWindowController;
  }

  get llng {
    return LatLng(currentLatitude, currentLongitude);
  }

  get markers {
    return _markers;
  }

  set username(String value) {
    _username = value;
  }



  set jwtoken(String value) {
    _jwtoken = value;
  }

  set newLotName(String value){
    _newLotName=value;
  }
  get getNewLotName{
    return _newLotName;
  }
  get getUsername{return _username;}
  get getJwtoken{return _jwtoken;}
  void reset() {
    _username = '';
    _jwtoken = '';
    _newLotName = '';
  }

  Future<void> getLots() async {
    final responseString = await httpService.getAll(_jwtoken);
    List<dynamic> decoded = jsonDecode(responseString);
    lots = decoded.map((json) => Lot.fromJson(json)).toList();
    notifyListeners();
  }

  Future<bool> addLot(LatLng position) async{
    bool response= await httpService.postLot(
        _jwtoken, _newLotName, position.latitude, position.longitude);
    return response;
  }
  Future<bool> addLot2(LatLng position,bool confirmation) async{
    if (confirmation == true) {
    if (_newLotName != '') {
      deletePotentialMarker();
      customInfoWindowController.hideInfoWindow!();
        bool added = await addLot(position);
        if (added) {
          triggerSuccessSnackbar();
        } else {
          triggerFailureSnackbar();
        }
        updateMarkers();
      _newLotName = '';
      return true;
      }
        else {
          triggerError();
        }
    }
    customInfoWindowController.hideInfoWindow!();
    deletePotentialMarker();
    _newLotName = '';
    return false;
  }
  Future<Position> getPosition() async {
    await getLots();
    Position tempPosition = await Geolocator.getCurrentPosition();
    currentLatitude = tempPosition.latitude;
    currentLongitude = tempPosition.longitude;
    updateMarkers();
    return Geolocator.getCurrentPosition();
  }

  bool checkMarker(LatLng input) {
    for (var element in _markers.values) {
      if (element.position == input) {
        return true;
      }
    }
    return false;
  }

  void deletePotentialMarker() {
    for (var key in _markers.keys) {
      if (_markers[key]?.markerId.value == 'potential') {
        _markers.remove(key);
        notifyListeners();
        break;
      }
    }
  }
  void createMarker(LatLng tapped) {
    _newLotName = '';
    Marker marker = Marker(
        markerId: const MarkerId("potential"),
        position: tapped,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () => {
              _customInfoWindowController.addInfoWindow!(
                PotentialMarker(
                  adminViewModel: this,
                  tapped: tapped,
                ),
                tapped,
              )
            });
    _markers[marker.markerId] = marker;
    notifyListeners();
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
              deletePotentialMarker(),
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
                NormalMarker(
                  adminViewModel: this,
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

  String getLotNameById(String lotId){
    for(Lot lot in lots){
      if(lot.id==lotId){
        return lot.lotName;
      }
    }
    return '';
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

}

