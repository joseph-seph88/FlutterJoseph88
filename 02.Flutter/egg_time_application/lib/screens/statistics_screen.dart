import 'package:egg_time_application/db_helper/button_and_db.dart';
import 'package:egg_time_application/widget/date_range_selector.dart';
import 'package:egg_time_application/widget/week_month_toggle.dart';
import 'package:egg_time_application/widget/weekday_selector.dart';
import 'package:egg_time_application/widget/weekly_todo_tracker.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Map<String, dynamic>> checkData = [];
  late DateTime firstDay;

  @override
  void initState() {
    super.initState();

    DateTime nowKST = DateTime.now().toUtc().add(const Duration(hours: 9));
    firstDay = nowKST.subtract(Duration(days: nowKST.weekday % 7));
  }

  void updateCheckData(List<Map<String, dynamic>> data) {
    setState(() {
      checkData = data;
    });
  }

  void updateDateRange(DateTime dateTime) {
    setState(() {
      firstDay = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("통계"), centerTitle: true),
        body: Column(
          children: [
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [WeekMonthToggle()]),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.blue, width: 2.0), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      DateRangeSelector(onDateRangeChanged: updateDateRange),
                      WeekdaySelector(firstDay: firstDay),
                      const Divider(height: 0.5),
                      WeeklyTodoTracker(checkData: checkData, firstDay: firstDay),
                    ],
                  )),
            ),
          ],
        ),
        floatingActionButton: ButtomTest(onCheckUpdated: updateCheckData),
      ),
    );
  }
}
