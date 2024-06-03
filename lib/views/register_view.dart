import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/RegisterViewModel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  String hintText = "Are you an admin?";
  late RegisterViewModel _registerViewModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registerViewModel = Provider.of<RegisterViewModel>(context, listen: false);
  }

  @override
  void dispose() {
    _registerViewModel.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool success;
    return Consumer<RegisterViewModel>(builder: (context, _, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Registration Page'),
        ),
        body: Padding(
          padding:
              EdgeInsets.fromLTRB(screenWidth * 0.1, 0, screenWidth * 0.1, 0),
          child: SingleChildScrollView(
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.1),
                SizedBox(
                  width: screenWidth * 0.8,
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                    onChanged: (value) {
                      _registerViewModel.username = value;
                    },
                    decoration: InputDecoration(
                      errorText: _registerViewModel.getUsername.length<6 ? 'Length at least 6': null,
                      labelText: 'Username',
                      labelStyle: const TextStyle(
                        fontSize: 22,
                      ),
                      fillColor: Colors.white,
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.blue,
                      )),
                      focusColor: Colors.blue,
                      floatingLabelStyle: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: screenWidth * 0.8,
                  child: TextFormField(
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                      onChanged: (value) {
                        _registerViewModel.password = value;
                      },
                      obscureText: _registerViewModel.getShowPassword,
                      decoration: InputDecoration(
                        errorText: !_registerViewModel
                                .validatePassword(_registerViewModel.password)
                            ? 'One uppercase letter, one symbol, and 8 characters'
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(_registerViewModel.getShowPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _registerViewModel.showPassword =
                                !_registerViewModel.getShowPassword;
                          },
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontSize: 22,
                        ),
                        fillColor: Colors.white,
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.blue,
                        )),
                        focusColor: Colors.blue,
                        floatingLabelStyle: const TextStyle(color: Colors.blue),
                      )),
                ),
                SizedBox(height: screenHeight * 0.1),
                SizedBox(
                  width: 0.8 * screenWidth,
                  height: screenHeight * 0.1,
                  child: SwitchListTile(
                    title: const Text(
                      'Are you an admin?',
                      style: TextStyle(fontSize: 22),
                    ),
                    value: _registerViewModel.admin,
                    activeColor: Colors.blue,
                    onChanged: (bool value) {
                      _registerViewModel.admin = value;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.07,
                  child: ElevatedButton(
                      onPressed: () async => {
                            success = await _registerViewModel.register(),
                            if (success == true)
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Registration Successful'),
                                      content: const Text(
                                          'You have registered successfully!'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text('OK',
                                              style: TextStyle(
                                                  color: Colors.blue)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              }
                            else
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Registration Failed'),
                                      content: const Text(
                                          'You have not been registered network issue/name already exists/invalid inputs'),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: const Text(
                                            'OK',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )
                              }
                          },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.blueAccent,
                          elevation: 5),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 25),
                      )),
                ),
              ],
            )),
          ),
        ),
      );
    });
  }
}
