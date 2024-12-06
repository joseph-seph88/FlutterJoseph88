import 'package:class_10_firebase/models/todo.dart';
import 'package:class_10_firebase/services/todo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final todoServiceProvider = Provider<TodoService>((ref) => TodoService());

final todoListProvider = StreamProvider<List<Todo>>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return todoService.getTodo();
});

final addTodoProvider = Provider((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return (Todo todo) => todoService.addTodo(todo);
});

final updateTodoProvider = Provider((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return (Todo todo) => todoService.updateTodo(todo);
});

final deleteTodoProvider = Provider((ref){
  final todoService = ref.watch(todoServiceProvider);
  return (String id) => todoService.deleteTodo(id);
});