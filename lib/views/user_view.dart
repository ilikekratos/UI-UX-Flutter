
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking/models/Lot.dart';
import 'package:parking/utils/utils.dart';
import 'package:parking/viewmodels/UserViewModel.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget{
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() =>_UserPageState();

}
class _UserPageState extends State<UserPage>{
  late UserViewModel _userViewModel;
  GoogleMapController? _controller;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userViewModel=Provider.of<UserViewModel>(context, listen: false);
    final arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _userViewModel.username=arguments['username'];
    _userViewModel.jwtoken=arguments['jwtoken'];
    _userViewModel.setNavigateCallback(
            (String username, String jwtoken, String lotId,String lotName) {
          Navigator.of(context).pushNamed(
            '/userLot',
            arguments: {
              'username': username,
              'jwtoken': jwtoken,
              'lotId': lotId,
              'lotName': lotName,
            },
          );
        });
  }
  @override
  void dispose() {
    _userViewModel.reset();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    {
      return Scaffold(
        appBar: AppBar(title: Text(capitalizeFirstLetter(_userViewModel.getUsername))),
        body: FutureBuilder<Position>(
          future: _userViewModel.getPosition(),
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData) {
              return Consumer<UserViewModel>(
                builder: (context, _, child) {
                  return Center(
                    child: Stack(
                      children: [
                        GoogleMap(
                          onTap: (LatLng tapped) {
                            _userViewModel
                                .customInfoWindowController.hideInfoWindow!();
                          },
                          onCameraMove: (position) {
                            _userViewModel
                                .customInfoWindowController.onCameraMove!();
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _userViewModel.customInfoWindowController
                                .googleMapController = controller;
                            _controller = controller;
                          },
                          initialCameraPosition: CameraPosition(

                            target: LatLng(snapshot.data!.latitude,
                                snapshot.data!.longitude),
                            zoom: 10,
                          ),
                          markers: Set<Marker>.of(_userViewModel.markers.values),
                        ),
                        CustomInfoWindow(
                          controller: _userViewModel.customInfoWindowController,
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

}
class UserMarker extends StatelessWidget {
  final UserViewModel userViewModel;
  Lot lot;
  UserMarker({
    super.key,
    required this.userViewModel,
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
                    userViewModel.customInfoWindowController.hideInfoWindow!();
                    userViewModel.triggerNavigate(userViewModel.getUsername,
                        userViewModel.getJwtoken, lot.id,lot.lotName);
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(130, 30)),
                    maximumSize: MaterialStateProperty.all(const Size(130, 30)),
                  ),
                  child: const Text(
                    'Enter lot',
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