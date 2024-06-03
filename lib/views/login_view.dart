import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/LoginViewModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginViewModel _loginViewModel;

  @override
  void initState() {

    super.initState();
  }
  @override
  void didChangeDependencies(){
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _loginViewModel.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool success;
    return Consumer<LoginViewModel>(builder: (context, _, child) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
            padding:
                EdgeInsets.fromLTRB(screenWidth * 0.1, 0, screenWidth * 0.1, 0),
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: screenHeight * 0.1),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontSize: 22,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.blue,
                            )),
                            focusColor: Colors.blue,
                            floatingLabelStyle: TextStyle(color: Colors.blue),
                          ),
                          onChanged: (value) =>
                              _loginViewModel.username = value),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: TextFormField(
                        obscureText: _loginViewModel.getShowPassword,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                          decoration:  InputDecoration(

                              suffixIcon: IconButton(
                              icon: Icon(_loginViewModel.getShowPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                _loginViewModel.showPassword =
                                !_loginViewModel.getShowPassword;

                              }),
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontSize: 22,
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.blue,
                            )),
                            focusColor: Colors.blue,
                            floatingLabelStyle: const TextStyle(color: Colors.blue),
                          ),
                          onChanged: (value) =>
                              _loginViewModel.password = value),
                    ),
                    SizedBox(height: screenHeight * 0.3),
                    SizedBox(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.07,
                        child: ElevatedButton(
                          onPressed: () async => {
                            success = await _loginViewModel.login(),
                            if (success == true)
                              {
                                if (_loginViewModel.admin == true)
                                  {
                                    Navigator.of(context).pushNamed('/admin',
                                        arguments: {
                                          'username': _loginViewModel.username,
                                          'jwtoken': _loginViewModel.jwtoken
                                        })
                                  }
                                else
                                  {
                                    Navigator.of(context).pushNamed('/user',
                                        arguments: {
                                          'username': _loginViewModel.username,
                                          'jwtoken': _loginViewModel.jwtoken
                                        })
                                  }
                              }
                            else
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Login Failed'),
                                      content: const Text('Error'),
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
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.lightBlue,
                            elevation: 5, // Elevation
                            shadowColor: Colors.blueAccent, // Shadow Color
                          ),
                          child: const Text('Login',
                              style: TextStyle(fontSize: 22)),
                        )),
                  ],
                ),
              ),
            )));});
  }
}
