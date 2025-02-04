import 'package:flutter/material.dart';

class TextFieldData {
  final String fieldName;
  final TextEditingController controller;
  final FocusNode focusNode;
  bool isValid;
  bool showField;
  String? errorText;

  TextFieldData(this.fieldName)
      : controller = TextEditingController(),
        focusNode = FocusNode(),
        isValid = false,
        showField = fieldName == "email";
}
