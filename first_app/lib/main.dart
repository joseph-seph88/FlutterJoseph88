import 'package:flutter/material.dart';
import 'package:first_app/gradient_container.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: const GradientContainer(
          Color.fromARGB(255, 35, 9, 80),
          Color.fromARGB(255, 24, 9, 50),
        ),
      ),
    ),
  );
}




// import 'package:flutter/material.dart';
// import 'package:first_app/gradient_container.dart';

// void main() {
//   runApp(
//     MaterialApp(
//       home: Scaffold(
//         body: const GradientContainer(
//           Color.fromARGB(255, 40, 13, 70),
//           Color.fromARGB(255, 28, 2, 41),
//         ),
//       ),
//     ),
//   );
// }
