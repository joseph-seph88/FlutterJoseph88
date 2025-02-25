import 'package:flutter/material.dart';

class WidgetStyle {
  // BoxDecoration chatBoxDecoration(bool isMine) {
  //   return BoxDecoration(
  //     color: isMine ? Colors.yellow : Colors.white,
  //     borderRadius: BorderRadius.circular(25),
  //   );
  // }

  BoxDecoration backBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
          Colors.blue[100] ?? Colors.blue,
          Colors.blueGrey[100] ?? Colors.blueAccent
        ]));
  }

  BoxDecoration coffeeBackBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
          Colors.brown[200] ?? Colors.brown,
          Colors.brown[100] ?? Colors.blueGrey
        ]));
  }

  BoxDecoration eduBackBoxDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
          Colors.black.withBlue(100).withGreen(20),
          Colors.blue.withGreen(150).withAlpha(255)
        ]));
  }

  BoxDecoration iconBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(25),
    );
  }

  BoxDecoration eduSendBoxDecoration() {
    return BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.withGreen(150).withAlpha(180));
  }

  BoxDecoration eduSideIconBoxDecoration() {
    return BoxDecoration(
      color: Colors.blue.withGreen(140).withAlpha(180),
      borderRadius: BorderRadius.circular(15),
    );
  }

  BoxDecoration eduTopicBoxDecoration() {
    return BoxDecoration(
      color: Colors.blue.withGreen(150).withAlpha(150),
      borderRadius: BorderRadius.circular(15),
    );
  }

  BoxDecoration eduIconBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    );
  }

  BoxDecoration eduHintBoxDecoration() {
    return BoxDecoration(
      color: Colors.indigo[300],
      borderRadius: BorderRadius.circular(15),
    );
  }

  BoxDecoration sendBoxDecoration(bool isMsg) {
    return BoxDecoration(
      color: isMsg ? Colors.blue[200] : Colors.white,
      borderRadius: BorderRadius.circular(25),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: Colors.indigo[300],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(15),
        bottomRight: Radius.circular(0),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(20), blurRadius: 3, spreadRadius: 1),
      ],
    );
  }

  BoxDecoration otherBoxDecoration() {
    return BoxDecoration(
      color: Colors.grey[100],
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(15),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(20), blurRadius: 3, spreadRadius: 1),
      ],
    );
  }

  BoxDecoration myPageBoxDecoration() {
    return BoxDecoration(
      color: Colors.indigo[50],
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(20), blurRadius: 3, spreadRadius: 1),
      ],
    );
  }

  BoxDecoration recommendBoxDecoration() {
    return BoxDecoration(
      color: Colors.deepOrange[50],
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(20), blurRadius: 3, spreadRadius: 1),
      ],
    );
  }

  BoxDecoration blueGreyBoxDecoration() {
    return BoxDecoration(
      color: Colors.white70,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(20), blurRadius: 3, spreadRadius: 1),
      ],
    );
  }

  BoxDecoration amberBorderBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.amber, width: 2),
      shape: BoxShape.circle,
    );
  }

  BoxDecoration redBorderBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.red, width: 2),
      shape: BoxShape.circle,
    );
  }

  BoxDecoration redBoxDecoration() {
    return BoxDecoration(
      color: Colors.red,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withAlpha(20), blurRadius: 3, spreadRadius: 1),
      ],
    );
  }
}
