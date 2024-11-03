import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ButtomTest extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onCheckUpdated;

  const ButtomTest({super.key, required this.onCheckUpdated});

  @override
  State<ButtomTest> createState() => _ButtomTestState();
}

class _ButtomTestState extends State<ButtomTest> {
  bool _toggle = true;
  late Database _database;
  List<Map<String, dynamic>> _check = [];

  void _onPressed() {
    if (_toggle) {
      DateTime now = DateTime.now();

      int index = 1;
      while (index < 11) {
        DateTime firstDay = DateTime(now.year, now.month - 1, now.day);
        while (firstDay.isBefore(now)) {
          _addCheck("할일 $index", DateFormat("yyyy-MM-dd").format(firstDay));
          firstDay = firstDay.add(Duration(days: Random().nextInt(4) + 1));
        }
        index++;
      }
    } else {
      _deleteCheck();
    }
    _toggle = !_toggle;
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY, todo TEXT, checkTime TEXT)",
        );
      },
      version: 1,
    );
    _fetchCheck();
  }

  Future<void> _addCheck(String todo, String checkTime) async {
    await _database.insert(
      'todo',
      {'todo': todo, 'checkTime': checkTime},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _fetchCheck();
  }

  Future<void> _deleteCheck() async {
    await _database.delete(
      'todo',
    );
    _fetchCheck();
  }

  Future<void> _fetchCheck() async {
    final List<Map<String, dynamic>> maps = await _database.query('todo');
    setState(() {
      _check = maps;
    });
    widget.onCheckUpdated(_check);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _onPressed,
      child: const Icon(Icons.add),
    );
  }
}
