import 'package:class_10_firebase/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/todo_notifier.dart';


final todoProvider = StateNotifierProvider<TodoNotifier, Todo>(
  (ref) => TodoNotifier(),
);
