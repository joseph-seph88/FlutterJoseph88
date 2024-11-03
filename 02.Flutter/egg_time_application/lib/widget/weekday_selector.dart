import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekdaySelector extends StatefulWidget {
  final DateTime firstDay;

  const WeekdaySelector({super.key, required this.firstDay});

  @override
  State<WeekdaySelector> createState() => _WeekdaySelectorState();
}

class _WeekdaySelectorState extends State<WeekdaySelector> {
  late List<bool> _weekDaySelect;

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  @override
  void didUpdateWidget(WeekdaySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDay != widget.firstDay) {
      _initializeSelection();
    }
  }

  void _initializeSelection() {
    final DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9));
    _weekDaySelect = List.filled(7, false);

    if (now.isAfter(widget.firstDay) && now.isBefore(widget.firstDay.add(const Duration(days: 7)))) {
      _weekDaySelect[(now.weekday % 7)] = true;
    }
  }

  void _onPressed(int index) {
    setState(() {
      _weekDaySelect[index] = !_weekDaySelect[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ToggleButtons(
            isSelected: _weekDaySelect,
            onPressed: _onPressed,
            borderColor: Colors.transparent,
            constraints: const BoxConstraints(minHeight: 32.0, minWidth: 20.0),
            children: _buildWeekDayButtons(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeekDayButtons() {
    return List.generate(7, (index) {
      final DateTime date = widget.firstDay.add(Duration(days: index));
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Text(DateFormat.E("ko").format(date), style: const TextStyle(fontSize: 15)),
      );
    });
  }
}
