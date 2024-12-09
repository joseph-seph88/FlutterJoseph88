import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoScreen extends ConsumerWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListProvider);
    final selectTodo = ref.watch(selectTodoProvider);

    if (selectTodo != null) {
      _titleController.text = selectTodo.title;
      _contentController.text = selectTodo.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "TODO",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Expanded(
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "제목",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: "내용",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                final titleText = _titleController.text.trim();
                final contentText = _contentController.text.trim();

                if (titleText.isNotEmpty && contentText.isNotEmpty) {
                  final newTodo = Todo(
                    id: '',
                    title: titleText,
                    content: contentText,
                    isDone: false,
                    timestamp: DateTime.now(),
                  );
                  ref.read(addTodoProvider)(newTodo);
                  _titleController.clear();
                  _contentController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("모든 필드를 입력해주세요.")),
                  );
                }
              },
              child: const Text("추가"),
            ),
          ),
          Expanded(
            child: todosAsync.when(
              data: (todos) => ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        onTap: () {
                          ref.read(selectTodoProvider.notifier).select(todo);
                        },
                        leading: IconButton(
                          icon: Icon(
                            todo.isDone
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: todo.isDone ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            final updatedTodo = todo.copyWith(
                              isDone: !todo.isDone,
                            );
                            ref.read(updateTodoProvider)(updatedTodo);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          todo.content,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.red),
                              onPressed: () {
                                final updateTodo = todo.copyWith(
                                  id: todo.id,
                                  title: _titleController.text.trim(),
                                  content: _contentController.text.trim(),
                                  timestamp: DateTime.now(),
                                );
                                ref
                                    .read(todoServiceProvider)
                                    .updateTodo(updateTodo);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                ref.read(deleteTodoProvider)(todo.id);
                              },
                            ),
                          ],
                        )),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
