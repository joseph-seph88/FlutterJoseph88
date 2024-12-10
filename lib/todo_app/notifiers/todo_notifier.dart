import 'package:class_10_firebase/todo_app/repositories/todo_firebase_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';


class TodoNotifier extends StateNotifier<List<Todo>> {
  final TodoFirebaseRepository _todoFirebaseRepository;

  TodoNotifier(this._todoFirebaseRepository) : super([]){
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todos = await _todoFirebaseRepository.getTodos().first;
    state = todos;
  }

  Future<void> addTodo(String title, String content) async {
    await _todoFirebaseRepository.addTodo(title, content);
    await loadTodos();
  }

  Future<void> updateTodo(String id, String title, String content) async {
    await _todoFirebaseRepository.updateTodo(id, title, content);
    await loadTodos();
  }

  Future<void> deleteTodo(String id) async {
    await _todoFirebaseRepository.deleteTodo(id);
    await loadTodos();
  }

  void toggleTodoDone(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(isDone: !todo.isDone);
      }
      return todo;
    }).toList();
  }

  void addComment(String todoId, String comment) {
    final todo = state.firstWhere((todo) => todo.id == todoId);
    todo.comments?.add(comment);
    state = [...state];
  }

  void deleteComment(String todoId, String comment) {
    final todo = state.firstWhere((todo) => todo.id == todoId);
    todo.comments?.remove(comment);
    state = [...state];
  }

}
