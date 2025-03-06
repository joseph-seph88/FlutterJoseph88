import 'package:flutter/material.dart';

class CustomSnackBar {
  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 800),
    ));
  }
}
