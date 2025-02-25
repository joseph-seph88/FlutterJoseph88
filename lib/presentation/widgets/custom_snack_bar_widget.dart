import 'package:flutter/material.dart';

class CustomSnackBarWidget {
  SnackBar showSnackBar(String content) {
    return SnackBar(
      content: Text(content),
      backgroundColor: Colors.blueGrey,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    );
  }


}
