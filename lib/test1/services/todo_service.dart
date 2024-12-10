import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class TodoService {
  final _todoCollection = FirebaseFirestore.instance.collection('todos');

  Future<void> addTodo(Todo todo) async {
    await _todoCollection.add(todo.toMap());
  }

  Stream<List<Todo>> getTodo() {
    return _todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Todo.fromFireStore(doc)).toList();
    });
  }

  Future<void> updateTodo(Todo todo) async {
    await _todoCollection.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }
}
