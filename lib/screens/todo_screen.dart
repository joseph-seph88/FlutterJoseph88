import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';

class TodoScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoProvider);
    final todoNotifier = ref.read(todoProvider.notifier);

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "새로운 Todo 추가",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final todoText = _controller.text.trim();
                    if (todoText.isNotEmpty) {
                      todoNotifier.addTodo(todoText);
                      _controller.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("내용을 입력해주세요.")),
                      );
                    }
                  },
                  child: const Text("추가"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoState.todoItems.length,
              itemBuilder: (context, index) {
                final todoItem = todoState.todoItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.indigo,
                    ),
                    title: Text(
                      todoItem,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      "할 일을 완료했는지 확인하세요.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon:
                      const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        todoNotifier.removeTodoAt(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
