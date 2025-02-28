import 'package:flutter/material.dart';

abstract class WidgetStyle {

  static BoxDecoration greyBtnDecoration(){
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.grey.shade100, Colors.grey.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 2),
          blurRadius: 3.0,
        ),
      ],
    );
  }

  static BoxDecoration indigoBtnDecoration(){
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.indigo.shade100,
          Colors.indigo.shade500
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.shade200.withOpacity(0.5),
          offset: Offset(0, 2),
          blurRadius: 4.0,
        ),
      ],
    );
  }

  static BoxDecoration greyTextFieldDecoration(){
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.grey.shade100, Colors.grey.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.grey.shade300, width: 0),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 2),
          blurRadius: 3.0,
        ),
      ],
    );
  }
}
