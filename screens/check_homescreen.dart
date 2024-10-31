import 'package:flutter/material.dart';
import 'dart:async';
import 'package:check_app_ver02/models/check_models.dart';
import 'package:check_app_ver02/db/check_database.dart';

class CheckHomescreen extends StatefulWidget {
  const CheckHomescreen({super.key});

  @override
  State<CheckHomescreen> createState() => _CheckHomescreenState();
}

class _CheckHomescreenState extends State<CheckHomescreen> {
  List<NameModel> studentInfo = [];
  List<NameModel> displayedListViewInfo = [];
  int currentIndex = 0;
  bool _checkToggle = false;

  Future<void> loadNames() async {
    await DatabaseHelper.instance.initializeDatabase();
    studentInfo = await DatabaseHelper.instance.fetchAllNames();
    if (studentInfo.isNotEmpty) {
      setState(() {
      });
    }
  }

  void _pickName() {
    if (studentInfo.isNotEmpty) {
      setState(() {
        currentIndex = (currentIndex + 1) % studentInfo.length;
        displayedListViewInfo.add(studentInfo[currentIndex]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'CHECK IN-OUT',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              'JOSEPH88',
              style: TextStyle(fontSize: 10),
            )
          ],
        ),
        centerTitle: true,
        toolbarHeight: 68,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(25),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await loadNames();
                  _pickName();
                  if(!_checkToggle){
                    _checkToggle = true;
                  }
                },
                label: const Icon(
                  Icons.access_time_filled,
                  size: 200,
                ),
              ),
            ),
          ),
          Switch(
            value: _checkToggle,
            onChanged: (value) {},
          ),
          Text(
            _checkToggle ? 'CHECK' : 'UNCHECK',
            style: TextStyle(
              color: Colors.deepPurple[200],
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: displayedListViewInfo.length,
                itemBuilder: (context, index) {
                  final nameModel = displayedListViewInfo[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_filled,
                            size: 40,
                            color: Color.fromRGBO(120, 50, 250, 0.5),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            'Name : ${nameModel.name}\n'
                            'Time : ${nameModel.time}\n'
                                'Late Count : ${nameModel.lateCount}',
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

