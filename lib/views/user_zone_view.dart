import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking/utils/utils.dart';
import 'package:parking/viewmodels/UserZoneViewModel.dart';
import 'package:provider/provider.dart';

class UserZonePage extends StatefulWidget {
  const UserZonePage({super.key});

  @override
  State<StatefulWidget> createState() => _UserZonePageState() ;
}

class _UserZonePageState extends State<UserZonePage> {
  late UserZoneViewModel _userZoneViewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userZoneViewModel = Provider.of<UserZoneViewModel>(context, listen: false);
    final arguments =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    _userZoneViewModel.username=arguments['username'];
    _userZoneViewModel.jwtoken=arguments['jwtoken'];
    _userZoneViewModel.zoneId=arguments['zoneId'];
    if(_userZoneViewModel.getZoneName=='error'){
      _userZoneViewModel.zoneName = arguments['zoneName'];
    }
    _userZoneViewModel.getSpots();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserZoneViewModel>(builder: (context, _, child)
    {
      return Scaffold(
          appBar: AppBar(
            title: Text(capitalizeFirstLetter(_userZoneViewModel.getZoneName)),

          ),
          body: _userZoneViewModel.isLoading ? const Center(child: CircularProgressIndicator()):
          Stack(
            children: [
              ListView.builder(
                  itemCount: _userZoneViewModel.spots.length,
                  itemBuilder: (context,index){
                    final item=_userZoneViewModel.spots[index];
                    return ListTile(
                      title: Text(capitalizeFirstLetter('Spot no.$index')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [IconButton(
                          icon: Icon(item.occupiedId!='-1' ? Icons.lock : Icons.directions_car),
                          color: item.occupiedId!='-1'  ? Colors.red : Colors.green,
                          onPressed: () {
                            if(item.occupiedId=="-1"){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Decision'),
                                  content: Text('Are you sure you want to book this spot?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Confirm'),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        bool check = await _userZoneViewModel.checkUser();
                                        if(check){
                                          showDialog(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: const Text('Alert'),
                                                content: const Text('You already have a spot booked. Booking this one will cancel the previous one!'),
                                                actions: <Widget>[
                                            TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                            },
                                            ),
                                            TextButton(child: Text('Confirm'),
                                            onPressed: () async{
                                              bool success = await _userZoneViewModel.updateSpot(item.id);
                                              showSnackBar(context, success, "Spot booked", "Failed to book spot");
                                              Navigator.of(context).pop();
                                            })]);
                                          });
                                        }
                                        else{
                                          bool success = await _userZoneViewModel.updateSpot(item.id);
                                          showSnackBar(context, success, "Spot booked", "Failed to book spot");
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            }
                            // Your onPressed logic here
                          },
                        )],
                      ),
                    );
                  }),
            ],
          )
      );

    });
  }

}