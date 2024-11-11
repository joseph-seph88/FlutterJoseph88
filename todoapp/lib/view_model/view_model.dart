import 'package:flutter/material.dart';

class ToDoViewModel extends ChangeNotifier{
  final List<String> _todoItems = [];
  final List<String> _subItems = [];
  final List<String> _details = [];

  List<String> get todoItems => _todoItems;
  List<String> get subItems => _subItems;
  List<String> get details => _details;

  void addItem(String item) {
    _todoItems.add(item);
    _subItems.add('');
    _details.add('');
    notifyListeners();
  }

  void removeItem(int index) {
    _todoItems.removeAt(index);
    _subItems.removeAt(index);
    _details.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index, String todoItem, String subItem, String detail) {
    _todoItems[index] = todoItem;
    _subItems[index] = subItem;
    _details[index] = detail;
    notifyListeners();
  }
}