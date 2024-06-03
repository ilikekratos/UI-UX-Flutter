import 'dart:convert';
import 'dart:developer';

import '../config.dart';
import 'package:http/http.dart' as http ;

import 'exceptions/HttpException.dart';
class LoginHttpService{

  Future<String> login(String username,String password) async
  {
    try{
    final response = await http.post(
      Uri.parse(myAPI().loginUrl),
      body: json.encode({'username':username,'password':password}),
      headers: {"Content-Type": "application/json"},
    ).timeout(const Duration(seconds: 5));
    if (response.statusCode != 202) {
      throw HttpServiceException('Failed to register');
    }
    return response.body;
    }
    catch(e){
      return "Error";
    }

  }
}