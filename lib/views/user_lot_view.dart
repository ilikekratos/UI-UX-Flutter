import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parking/utils/utils.dart';
import 'package:parking/viewmodels/UserLotViewModel.dart';
import 'package:provider/provider.dart';
class UserLotPage extends StatefulWidget{
  const UserLotPage({super.key});

  @override
  State<StatefulWidget> createState() =>_UserLotPageState();
}

class _UserLotPageState extends State<UserLotPage>{
  late UserLotViewModel _userLotViewModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userLotViewModel = Provider.of<UserLotViewModel>(context, listen: false);
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _userLotViewModel.jwtoken = arguments['jwtoken'];
    _userLotViewModel.lotId = arguments['lotId'];
    if(_userLotViewModel.getLotName=='error'){
      _userLotViewModel.lotName = arguments['lotName'];
    }
    _userLotViewModel.getZones();
    _userLotViewModel.username = arguments['username'];
    _userLotViewModel.setNavigateCallback(
            (String username,String jwtoken, String zoneId,String zoneName) {
          Navigator.of(context).pushNamed(
            '/userSpots',
            arguments: {
              'username': username,
              'jwtoken': jwtoken,
              'zoneId': zoneId,
              'zoneName': zoneName,
            },
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserLotViewModel>(
      builder: (context, _, child) {
        return Scaffold(
          appBar: AppBar(
            title:  Text(capitalizeFirstLetter(_userLotViewModel.getLotName) ),
          ),

          body: _userLotViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
            children: [
              ListView.builder(
                itemCount: _userLotViewModel.zones.length,
                itemBuilder: (context, index) {
                  final item = _userLotViewModel.zones[index];
                  return Card(
                    elevation: 2.0, // Adds a slight shadow effect
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adds space around the card
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adds padding inside the tile
                      title: Text(
                        capitalizeFirstLetter(item.zoneName),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              _userLotViewModel.triggerNavigate(_userLotViewModel.getUsername,_userLotViewModel.getJwtoken, _userLotViewModel.zones[index].id, _userLotViewModel.zones[index].zoneName);

                              // Implement your edit logic here
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue, // Text color
                            ),
                            child: const Text('Enter Zone'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

}