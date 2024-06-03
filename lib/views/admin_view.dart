import 'dart:developer';
import 'package:clippy_flutter/triangle.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/models/Lot.dart';
import 'package:parking/utils/utils.dart';
import 'package:parking/viewmodels/AdminViewModel.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:custom_info_window/custom_info_window.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late AdminViewModel _adminViewModel;
  GoogleMapController? _controller;
@override
void initState(){
  super.initState();

}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminViewModel = Provider.of<AdminViewModel>(context, listen: false);
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _adminViewModel.username = arguments['username'];
    _adminViewModel.jwtoken = arguments['jwtoken'];
    _adminViewModel.setShowError(() async{
      await showErrorDialog(context);
    });
    _adminViewModel.setSuccessSnackbarCallback(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lot added successfully!")),
      );
    });
    _adminViewModel.setFailureSnackbarCallback(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add lot.")),
      );
    });
    _adminViewModel.setShowDialogCallback((LatLng tapped) async {
      bool? confirmation = await showConfirmationDialog(context);
      await _adminViewModel.addLot2(tapped,confirmation!);
    });
    _adminViewModel.setNavigateCallback(
            (String username, String jwtoken, String lotId,String lotName) {
          Navigator.of(context).pushNamed(
            '/adminLot',
            arguments: {
              'jwtoken': jwtoken,
              'lotId': lotId,
              'lotName': lotName,
            },
          );
        });
  }

  @override
  void dispose() {
    _adminViewModel.reset();
    super.dispose();
  }

  Future<bool?> showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Light blue background
          title: Text(
            'Confirm',
            style: TextStyle(color: Colors.blue.shade900), // Dark blue text
          ),
          content: Text(
            'Do you want to add this parking spot?',
            style: TextStyle(color: Colors.blue.shade900), // Dark blue text
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade900, // Dark blue text
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade900, // Dark blue text
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showErrorDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Light blue background
          title: Text(
            'Error',
            style: TextStyle(color: Colors.blue.shade900), // Dark blue text
          ),
          content: Text(
            'You added an empty name for zone',
            style: TextStyle(color: Colors.blue.shade900), // Dark blue text
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade900, // Dark blue text
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: FutureBuilder<Position>(
        future: _adminViewModel.getPosition(),
        builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          if (snapshot.hasData) {
            return Consumer<AdminViewModel>(
              builder: (context, _, child) {
                return Center(
                  child: Stack(
                    children: [
                      GoogleMap(

                        onTap: (LatLng tapped) {
                          _adminViewModel.deletePotentialMarker();
                          _adminViewModel
                              .customInfoWindowController.hideInfoWindow!();
                          if (!_adminViewModel.checkMarker(tapped)) {
                            _adminViewModel.createMarker(tapped);
                          }
                        },
                        onCameraMove: (position) {
                          _adminViewModel
                              .customInfoWindowController.onCameraMove!();
                        },
                        onMapCreated: (GoogleMapController controller) {
                          _adminViewModel.customInfoWindowController
                              .googleMapController = controller;
                          _controller = controller;
                        },
                        initialCameraPosition: CameraPosition(

                          target: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude),
                          zoom: 10,
                        ),
                        markers: Set<Marker>.of(_adminViewModel.markers.values),
                      ),
                      CustomInfoWindow(
                        controller: _adminViewModel.customInfoWindowController,
                        height: 120,
                        width: 150,
                        offset: 40,
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  TrianglePainter({
    required this.strokeColor,
    required this.strokeWidth,
    required this.paintingStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.paintingStyle != paintingStyle;
  }
}

class PotentialMarker extends StatelessWidget {
  final AdminViewModel adminViewModel;
  final LatLng tapped;

  const PotentialMarker({
    super.key,
    required this.adminViewModel,
    required this.tapped,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                hintText: 'zone name',
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (value) {
                                adminViewModel.newLotName = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            adminViewModel.triggerDialog(tapped);
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(130, 30)),
                              maximumSize: MaterialStateProperty.all(
                                  const Size(130, 30))),
                          child: const Text('Add Park Lot',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12)),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Colors.blue,
            width: 20.0,
            height: 10.0,
          ),
        ),
      ],
    );
  }
}

class NormalMarker extends StatelessWidget {
  final AdminViewModel adminViewModel;
  Lot lot;
  NormalMarker({
    super.key,
    required this.adminViewModel,
    required this.lot,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                    height: 30,
                    width: 130,
                    child: Center(
                      child: Text(
                        capitalizeFirstLetter(lot.lotName.toString()),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 4,
                ),
                // Removed SizedBox
                ElevatedButton(
                  onPressed: () {
                    adminViewModel.customInfoWindowController.hideInfoWindow!();
                    adminViewModel.triggerNavigate(adminViewModel.getUsername,
                        adminViewModel.getJwtoken, lot.id,lot.lotName);
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(130, 30)),
                    maximumSize: MaterialStateProperty.all(const Size(130, 30)),
                  ),
                  child: const Text(
                    'Edit Lot',
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Colors.blue,
            width: 20.0,
            height: 10.0,
          ),
        )
      ],
    );
  }
}


