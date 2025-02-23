import 'package:flutter/material.dart';
import 'custom_show_dialog.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: FloatingActionButton(
          onPressed: () {
            CustomShowDialog().showAddEventDialog(context);
          },
          backgroundColor: Colors.teal[300],
          elevation: 10,
          shape: CircleBorder(),
          child: Icon(Icons.add, size: 38, color: Colors.white)),
    );
  }
}
