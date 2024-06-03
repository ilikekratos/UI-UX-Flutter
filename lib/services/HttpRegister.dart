import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http ;

import '../config.dart';
import 'exceptions/HttpException.dart';

class RegisterHttpService{

  Future<String> register(String username,String password,bool admin) async
  {
    try{
    final response = await http.post(
      Uri.parse(myAPI().registerUrl),
      body: json.encode({'username':username,'password':password,'admin':admin}),
      headers: {"Content-Type": "application/json"},
    ).timeout(const Duration(seconds: 5));
    if (!(response.statusCode == 201 || response.statusCode==200)) {
      throw HttpServiceException('Failed to register');
    }
    return response.body;
    }
    catch(e){
      return "Error";
    }
  }
}