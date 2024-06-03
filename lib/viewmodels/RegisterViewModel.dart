import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:parking/config.dart';

import '../services/HttpRegister.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class RegisterViewModel extends ChangeNotifier{
  final RegisterHttpService httpService;
  RegisterViewModel({required this.httpService});
  String _username='';
  String _password='';
  bool _admin=false;
  bool _showPassword = false;
  String get getUsername => _username;
  set showPassword(bool value){

    _showPassword=value;
    notifyListeners();
  }

  bool get getShowPassword => _showPassword;
  String get username => _username;
  String get password => _password;
  bool get admin =>_admin;
  void reset() {
    _username = '';
    _password = '';
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
  set admin(bool value) {
    _admin = value;
    notifyListeners();
  }
  Future<bool> register() async {
    if(_username.length<6 || !validatePassword(_password)){
      return false;
    }
    try {
      final responseString = await httpService.register(toLowerCase(_username), _password,_admin);
      if(responseString!="Error"){
        return true;
      }
      else{
        return false;
      }
    }
    catch (error){
      return false;}
  }
  bool validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*]).{8,}$');
    return regex.hasMatch(password);
  }
  String toLowerCase(String input) {
    return input.toLowerCase();
  }
}