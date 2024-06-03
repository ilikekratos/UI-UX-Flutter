import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import '../services/HttpLogin.dart';

class LoginViewModel extends ChangeNotifier{

  final LoginHttpService httpService;
  LoginViewModel({required this.httpService});
  String _username='';
  String _password='';
  bool _showPassword=false;
  get getShowPassword =>_showPassword;
  set showPassword(bool value){
    _showPassword=value;
    notifyListeners();
  }
  bool _admin= false;
  String _jwtoken='';
  String get jwtoken => _jwtoken;
  String get username => _username;
  String get password => _password;
  bool get admin => _admin;
  void reset() {
    _username = '';
    _password = '';
    _jwtoken='';
    _admin=false;
  }
  set username(String value) {
    _username = value;
    notifyListeners();
  }
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> login() async {
    final responseString= await httpService.login(_username,_password);
    if(responseString!="Error"){
      final responseJson = jsonDecode(responseString);
      _jwtoken=responseJson['token'];
      _admin=responseJson['admin'];
      return true;
    }
    else{
      return false;
    }
  }
}