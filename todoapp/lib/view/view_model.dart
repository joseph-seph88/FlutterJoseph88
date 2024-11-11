import 'package:flutter/material.dart';

class ToDoViewModel extends ChangeNotifier{
  final List<String> _todoItems = [];
  List<String> get todoItems => _todoItems;

  void addItem(String item){
    _todoItems.add(item);
    notifyListeners();
  }

  void removeItem(int index){
    _todoItems.removeAt(index);
    notifyListeners();
  }
}