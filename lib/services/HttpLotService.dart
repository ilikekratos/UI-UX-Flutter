







import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:parking/config.dart';
import 'package:parking/models/Lot.dart';
import 'package:http/http.dart' as http ;
import 'package:parking/services/exceptions/HttpException.dart';

class HttpLotService{
  Future<String> getAll(String token) async
  {
    try{
      final response = await http.get(
        Uri.parse(myAPI().getLotUrl),
        headers: {"Content-Type": "application/json",
                  "Authorization": token},
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode==200)) {
        log("Failed to get");
        throw HttpServiceException('Failed to get');
      }
      return response.body;
    }
    catch(e){
      return e.toString();
    }
  }
  Future<bool> postLot(String token,String name,double latitude, double longitude) async
  {
    try{
      log("check");
      log(name);
      final response = await http.post(
        Uri.parse(myAPI().addLotUrl),
        headers: {"Content-Type": "application/json",
          "Authorization": token},
        body: json.encode({'lotName':name,'latitude':latitude,'longitude':longitude})
      ).timeout(const Duration(seconds: 5));
      if (!(response.statusCode==201)) {
        log("Failed to post");
        log(response.toString());
        throw HttpServiceException('Failed to post');
      }
      return true;
    }
    catch(e){
      return false;
    }
  }
}