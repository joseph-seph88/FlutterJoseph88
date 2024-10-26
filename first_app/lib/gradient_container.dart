import 'package:flutter/material.dart';
import 'package:first_app/dice_roller.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  const GradientContainer(this.color1, this.color2, {super.key});

  final Color color1;
  final Color color2;

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: DiceRoller(),
      ),
    );
  }
}












// import 'package:first_app/dice_roller.dart';
// import 'package:first_app/main.dart';
// import 'package:flutter/material.dart';

// const startAlignment = Alignment.topLeft;
// const endAlignment = Alignment.bottomRight;

// class GradientContainer extends StatelessWidget {
//   const GradientContainer(this.color1, this.color2, {super.key});

//   const GradientContainer.puple({super.key})
//       : color1 = Colors.deepPurple,
//         color2 = Colors.indigo;

//   final Color color1;
//   final Color color2;

//   @override
//   Widget build(context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color1, color2],
//           begin: startAlignment,
//           end: endAlignment,
//         ),
//       ),
//       child: Center(
//         child: DiceRoller(),
//       ),
//     );
//   }
// }


// // class GradientContainer extends StatelessWidget {
// //   const GradientContainer(this.color1, this.color2, {super.key});

// //   final Color color1;
// //   final Color color2;

// //   @override
// //   Widget build(context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [color1, color2],
// //           begin: startAlignment,
// //           end: endAlignment,
// //         ),
// //       ),
// //       child: Center(
// //         child: StyledText('Welcome Joseph!'),
// //       ),
// //     );
// //   }
// // }
