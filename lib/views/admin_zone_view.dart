import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking/utils/utils.dart';
import 'package:parking/viewmodels/AdminZoneViewModel.dart';
import 'package:provider/provider.dart';
class AdminZonePage extends StatefulWidget {
  const AdminZonePage({super.key});

  @override
  State<StatefulWidget> createState() => _AdmingZonePageState() ;
}

class _AdmingZonePageState extends State<AdminZonePage> {
  late AdminZoneViewModel _adminZoneViewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _adminZoneViewModel = Provider.of<AdminZoneViewModel>(context, listen: false);
    final arguments =
    ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;
    _adminZoneViewModel.jwtoken=arguments['jwtoken'];
    _adminZoneViewModel.zoneId=arguments['zoneId'];
    if(_adminZoneViewModel.getZoneName=='error'){
      _adminZoneViewModel.zoneName = arguments['zoneName'];
    }
    log(_adminZoneViewModel.getZoneName);
    _adminZoneViewModel.getSpots();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminZoneViewModel>(builder: (context, _, child)
    {
      return Scaffold(
      appBar: AppBar(
        title: Text(capitalizeFirstLetter(_adminZoneViewModel.getZoneName)),
        actions: [ IconButton(
          icon: const Icon(Icons.edit),
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _adminZoneViewModel.newZoneName='';
                return AlertDialog(
                  title: const Text('Edit Zone Name'),
                  content: TextField(
                    onChanged: (value) {
                      _adminZoneViewModel.newZoneName = value;
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
                      onPressed: () async {
                        if(_adminZoneViewModel.getNewZoneName!=''){
                          bool success=await _adminZoneViewModel.editName();
                          Navigator.of(context).pop();
                          if(success==true){
                            _adminZoneViewModel.zoneName=_adminZoneViewModel.getNewZoneName;
                            _adminZoneViewModel.getSpots();
                          }
                          showSnackBar(context,success,'Zone edited successfully!','Failed to edit Zone.');
                        }
                        else{
                          Navigator.of(context).pop();
                          showSnackBar(context,false,'Zone edited successfully!','Failed to edit Zone.');
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
    body: _adminZoneViewModel.isLoading ? const Center(child: CircularProgressIndicator()):
        Stack(
          children: [
            ListView.builder(
              itemCount: _adminZoneViewModel.spots.length,
                itemBuilder: (context,index){
                final item=_adminZoneViewModel.spots[index];
                return ListTile(
                  title: Text(capitalizeFirstLetter('Spot no.$index')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [IconButton(
                      icon: Icon(item.occupiedId!='-1' ? Icons.lock : Icons.lock_open),
                      color: item.occupiedId!='-1'  ? Colors.red : Colors.green,
                      onPressed: () {
                        if(item.occupiedId!=-1){
                          _adminZoneViewModel.clearSpot(item.id);
                        }
                    // Your onPressed logic here
                  },
                ),IconButton(
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
                                    bool success= await _adminZoneViewModel.deleteSpot(item.id);
                                    Navigator.of(context).pop();
                                    showSnackBar(context,success,'Spot deleted successfully!','Failed to delete Spot.');
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )],
                  ),
                );
                }),
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
                        _adminZoneViewModel.addSpot();
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
                            'Add Spot',
                            style: TextStyle(fontSize: 12,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        )
    );
      
    });
  }
}