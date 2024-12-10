import 'package:class_10_firebase/todo_app/repositories/todo_firebase_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../notifiers/todo_notifier.dart';

final titleProvider = Provider<TextEditingController>((ref)=>TextEditingController());
final contentProvider = Provider<TextEditingController>((ref)=>TextEditingController());


final todoFirebaseProvider = Provider<TodoFirebaseRepository>((ref) {
  return TodoFirebaseRepository();
});

final todoStateProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  final firebaseTodoService = ref.watch(todoFirebaseProvider);
  return TodoNotifier(firebaseTodoService);
});