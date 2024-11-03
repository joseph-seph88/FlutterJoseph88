import 'package:flutter/material.dart';

class WeekMonthToggle extends StatefulWidget {
  const WeekMonthToggle({super.key});

  @override
  State<WeekMonthToggle> createState() => _WeekMonthToggleState();
}

class _WeekMonthToggleState extends State<WeekMonthToggle> {
  final List<String> _labels = ["주간", "월간"];
  int _selectedIndex = 0;

  void _onPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
        onPressed: _onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: Colors.red[700],
        selectedColor: Colors.white,
        fillColor: Colors.red[200],
        color: Colors.red[400],
        constraints: BoxConstraints(
          minHeight: 40.0,
          minWidth: MediaQuery.of(context).size.width * 0.4,
        ),
        isSelected: _labels.map((label) => _labels.indexOf(label) == _selectedIndex).toList(),
        children: _labels.map((label) => Text(label)).toList());
  }
}
