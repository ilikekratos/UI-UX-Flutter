import 'package:flutter/material.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input; // Return empty string if input is empty
  return input.substring(0, 1).toUpperCase() + input.substring(1);
}
void showSnackBar(BuildContext context,bool success,String good,String bad) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(success ? good  :bad ),
    ),
  );
}