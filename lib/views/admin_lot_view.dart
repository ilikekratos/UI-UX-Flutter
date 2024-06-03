






import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking/utils/utils.dart';
import 'package:parking/viewmodels/AdminLotViewModel.dart';
import 'package:parking/viewmodels/AdminViewModel.dart';
import 'package:provider/provider.dart';

class AdminLotPage extends StatefulWidget {
  const AdminLotPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminLotPageState();
}
class _AdminLotPageState extends State<AdminLotPage> {
  late AdminLotViewModel _adminLotViewModel;
  late AdminViewModel _adminViewModel;
  @override
  void dispose() {
    _adminLotViewModel.reset();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminLotViewModel = Provider.of<AdminLotViewModel>(context, listen: false);
    _adminViewModel=Provider.of<AdminViewModel>(context, listen: false);
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _adminLotViewModel.jwtoken = arguments['jwtoken'];
    _adminLotViewModel.lotId = arguments['lotId'];
    if(_adminLotViewModel.getLotName=='error'){
      _adminLotViewModel.lotName = arguments['lotName'];
    }
    _adminLotViewModel.getZones();
    _adminLotViewModel.setNavigateCallback(
            (String jwtoken, String zoneId,String zoneName) {
          Navigator.of(context).pushNamed(
            '/adminSpots',
            arguments: {
              'jwtoken': jwtoken,
              'zoneId': zoneId,
              'zoneName': zoneName,
            },
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminLotViewModel>(
      builder: (context, _, child) {
        return Scaffold(
          appBar: AppBar(
            title:  Text(capitalizeFirstLetter(_adminLotViewModel.getLotName) ),
            actions: [ IconButton(
              icon: const Icon(Icons.edit),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  _adminLotViewModel.newLotName='';
                  return AlertDialog(
                    title: const Text('Edit Lot Name'),
                    content: TextField(
                      onChanged: (value) {
                        _adminLotViewModel.newLotName = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Lot Name',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if(_adminLotViewModel.getNewLotName!=''){
                            bool success=await _adminLotViewModel.editName();
                            Navigator.of(context).pop();
                            if(success==true){
                              _adminLotViewModel.lotName=_adminLotViewModel.getNewLotName;
                              _adminViewModel.getLots();
                            }
                            showSnackBar(context,success,'Lot edited successfully!','Failed to edited lot.');
                          }
                          else{
                            Navigator.of(context).pop();
                            showSnackBar(context,false,'Lot edited successfully!','Failed to edited lot.');
                          }
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  );
                },
              );
            },
            ),],
          ),

          body: _adminLotViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
            children: [
              ListView.builder(
                itemCount: _adminLotViewModel.zones.length,
                itemBuilder: (context, index) {
                  final item = _adminLotViewModel.zones[index];
                  return ListTile(
                    title: Text(capitalizeFirstLetter(item.zoneName)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () {
                            _adminLotViewModel.triggerNavigate(_adminLotViewModel.getJwtoken, _adminLotViewModel.zones[index].id, _adminLotViewModel.zones[index].zoneName);

                            // Implement your edit logic here
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            // Show a dialog for confirmation
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirmation"),
                                  content: const Text("Are you sure you want to delete this item?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: ()async {
                                        // Perform the deletion
                                        bool success= await _adminLotViewModel.deleteZone(item.id);
                                        Navigator.of(context).pop();
                                        showSnackBar(context,success,'Zone deleted successfully!','Failed to delete zone.');
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 64,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 75, // Set width of the button
                    height: 75, // Set height of the button
                    child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _adminLotViewModel.newZoneName='';
                            return AlertDialog(
                              title: const Text('Add Zone'),
                              content: TextField(
                                onChanged: (value) {
                                  _adminLotViewModel.newZoneName = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Enter Zone Name',
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if(_adminLotViewModel.getNewZoneName!=''){
                                      _adminLotViewModel.addZone();
                                      Navigator.of(context).pop();
                                    }
                                    else{
                                      Navigator.of(context).pop();
                                      showSnackBar(context,false,'Zone added successfully!','Failed to add zone.');
                                    }
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40, // Increased icon size
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add Zone',
                            style: TextStyle(fontSize: 12,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}