import 'dart:math';
import 'package:flutter/material.dart';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  var currentDiceRoll = 1;

  void rollDice() {
    setState(() {
      currentDiceRoll = randomizer.nextInt(6) + 1;
    });
  }

  @override
  Widget build(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/dice-$currentDiceRoll.png',
          width: 250,
        ),
        SizedBox(height: 20),
        OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color.fromARGB(255, 79, 154, 82),
            ),
            child: Text('Wellever..')),
        ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.greenAccent),
            child: Text('Whatever~')),
        TextButton(
            onPressed: rollDice,
            style: TextButton.styleFrom(
                padding: EdgeInsets.only(top: 20),
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 28)),
            child: const Text('Roll Dice88')),
      ],
    );
  }
}






// import 'package:flutter/material.dart';
// import 'dart:math';

// final randomizer = Random();

// class DiceRoller extends StatefulWidget {
//   const DiceRoller({super.key});

//   @override
//   State<DiceRoller> createState() {
//     return _DiceRollerState();
//   }
// }

// class _DiceRollerState extends State<DiceRoller> {
//   var currentDiceRoll = 2;

//   void rollDice() {
//     setState(() {
//       currentDiceRoll = randomizer.nextInt(6) + 1;
//     });
//   }

//   @override
//   Widget build(context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Image.asset(
//           'assets/images/dice-$currentDiceRoll.png',
//           width: 200,
//         ),
//         // OutlinedButton(onPressed: onPressed, child: child)
//         // ElevatedButton(onPressed: onPressed, child: child)
//         const SizedBox(height: 20),
//         TextButton(
//           onPressed: rollDice,
//           style: TextButton.styleFrom(
//             // padding: const EdgeInsets.only(
//             //   top: 30,
//             // ),
//             foregroundColor: Colors.white,
//             textStyle: const TextStyle(
//               fontSize: 28,
//             ),
//           ),
//           child: const Text('Roll Dice'),
//         ),
//       ],
//     );
//   }
// }
