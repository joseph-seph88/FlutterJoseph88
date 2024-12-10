import 'package:class_10_firebase/todo_app/models/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoFirebaseRepository {
  final _todoCollection = FirebaseFirestore.instance.collection('todos');

  Future<void> addTodo(String title, String content) async {
    await _todoCollection.add(
        Todo(title: title, content: content, isDone: false)
            .toMap());
  }

  Future<void> updateTodo(String id, String title, String content) async {
    await _todoCollection.doc(id).update(
        Todo(id: id, title: title, content: content, isDone: false)
            .toMap());
  }

  Stream<List<Todo>> getTodos() {
    return _todoCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }

  Future<void> addComment(String todoId, String comment) async {
    try {
      final todoDocRef = _todoCollection.doc(todoId);
      await todoDocRef.update({
        'comments': FieldValue.arrayUnion([comment]),
      });
    } catch (e) {
      throw Exception("댓글 추가 실패: $e");
    }
  }

  Future<void> deleteComment(String todoId, String comment) async {
    try {
      final todoDocRef = _todoCollection.doc(todoId);
      await todoDocRef.update({
        'comments': FieldValue.arrayRemove([comment]),
      });
    } catch (e) {
      throw Exception("댓글 삭제 실패: $e");
    }
  }
}


