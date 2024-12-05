import 'package:class_10_firebase/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoNotifier extends StateNotifier<Todo> {
  TodoNotifier() : super(const Todo([]));

  void addTodo(String todo) {
    if (todo.isNotEmpty) {
      final updatedTodos = [...state.todoItems, todo];
      state = state.copyWith(todoItems: updatedTodos);
    }
  }

  void removeTodoAt(int index) {
    if (index >= 0 && index < state.todoItems.length) {
      final updatedTodos = List<String>.from(state.todoItems)
        ..removeAt(index);
      state = state.copyWith(todoItems: updatedTodos);
    }
  }
}

