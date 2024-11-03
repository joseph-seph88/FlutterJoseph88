import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatefulWidget {
  final ValueChanged<DateTime> onDateRangeChanged;

  const DateRangeSelector({super.key, required this.onDateRangeChanged});

  @override
  State<DateRangeSelector> createState() => _DateRangeSelectorState();
}

class _DateRangeSelectorState extends State<DateRangeSelector> {
  late DateTime firstDay;

  @override
  void initState() {
    super.initState();
    DateTime nowKST = DateTime.now().toUtc().add(const Duration(hours: 9));
    firstDay = nowKST.subtract(Duration(days: nowKST.weekday % 7));
  }

  void _onPressed(bool isBack) {
    setState(() {
      firstDay = firstDay.add(Duration(days: isBack ? -7 : 7));
      widget.onDateRangeChanged(firstDay);
    });
  }

  String getFormattedDateRange() {
    return "${DateFormat("MM월 dd일").format(firstDay)} ~ ${DateFormat("MM월 dd일").format(firstDay.add(const Duration(days: 6)))}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => _onPressed(true)),
        Text(getFormattedDateRange(), style: const TextStyle(fontSize: 20)),
        IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => _onPressed(false)),
      ],
    );
  }
}
