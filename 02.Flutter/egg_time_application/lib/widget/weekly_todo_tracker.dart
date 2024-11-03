import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class WeeklyTodoTracker extends StatefulWidget {
  final List<Map<String, dynamic>> checkData;
  final DateTime firstDay;

  const WeeklyTodoTracker({super.key, required this.firstDay, required this.checkData});

  @override
  State<WeeklyTodoTracker> createState() => _WeeklyTodoTrackerState();
}

class _WeeklyTodoTrackerState extends State<WeeklyTodoTracker> {
  late Map<String, List<Map<String, dynamic>>> groupedCheckData = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(WeeklyTodoTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.firstDay != widget.firstDay || oldWidget.checkData != widget.checkData) {
      _initializeSelection();
    }
  }

  void _initializeSelection() {
    for (Map<String, dynamic> check in widget.checkData) {
      final String todo = check['todo'];
      groupedCheckData[todo] = groupedCheckData[todo] ?? [];
      groupedCheckData[todo]!.add(check);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoKeys = groupedCheckData.keys.toList();

    return Column(
      children: List.generate(todoKeys.length, (index) {
        final todo = todoKeys[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext _) => CalendarScreen(todo: todo, todoData: groupedCheckData[todo]!))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Padding(padding: const EdgeInsets.only(left: 16), child: Text(todo))),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 32.0, minWidth: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _buildDateIconByTody(groupedCheckData[todo]!),
                      ),
                    ),
                  )),
                ],
              ),
            ),
            if (index < todoKeys.length - 1) const Padding(padding: EdgeInsets.only(right: 16, left: 16), child: Divider(height: 0.1))
          ],
        );
      }),
    );
  }

  List<Widget> _buildDateIconByTody(List<Map<String, dynamic>> todoData) {
    Set<String> checkDates = todoData.map((item) => item['checkTime'].toString()).toSet();

    return List.generate(7, (index) {
      final DateTime date = widget.firstDay.add(Duration(days: index));
      final String formattedDate = DateFormat("yyyy-MM-dd").format(date);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: Icon(
          checkDates.contains(formattedDate) ? Icons.circle : Icons.circle_outlined,
          color: Colors.blue,
          size: 15,
        ),
      );
    });
  }
}

class CalendarScreen extends StatelessWidget {
  final String todo;
  final List<Map<String, dynamic>> todoData;

  const CalendarScreen({super.key, required this.todo, required this.todoData});

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    List<String> list = todoData.map((item) => item['checkTime'].toString()).toSet().toList();
    list.sort();

    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(todo),
      ),
      body: Center(
        child: TableCalendar(
          locale: "ko-KR",
          firstDay: DateTime(now.year, now.month - 3, now.day),
          lastDay: DateTime(now.year, now.month + 3, now.day),
          focusedDay: now,
          calendarFormat: CalendarFormat.month,
          //headerVisible: false,
          daysOfWeekHeight: 100,
        ),
        // const Expanded(child: CalendarScreen()),
      ),
    );
  }
}
