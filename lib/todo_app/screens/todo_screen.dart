import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/todo_provider.dart';
import '../widgets/popup1.dart';
import '../widgets/popup2.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoStateProvider);
    final titleController = ref.watch(titleProvider);
    final contentController = ref.watch(contentProvider);

    void showCommentPopup1(BuildContext context, String todoId) {
      showDialog(
        context: context,
        builder: (context) {
          return Popup1(todoId: todoId);
        },
      );
    }

    void showCommentPopup2(BuildContext context, String todoId) {
      showDialog(
        context: context,
        builder: (context) {
          return Popup2(todoId: todoId);
        },
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "제목",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: "내용",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ElevatedButton(
            onPressed: () {
              final titleText = titleController.text.trim();
              final contentText = contentController.text.trim();

              if (titleText.isNotEmpty && contentText.isNotEmpty) {
                ref.read(todoFirebaseProvider).addTodo(titleText, contentText);
                ref.read(todoStateProvider.notifier).addTodo(titleText, contentText);

                titleController.clear();
                contentController.clear();
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
          child: ListView.builder(
            itemCount: todoState.length,
            itemBuilder: (context, index) {
              final todo = todoState[index];
              // final commentState = ref.watch(commentStateProvider(todo.id!));

              return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
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
                    leading: IconButton(
                      icon: Icon(
                        todo.isDone
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: todo.isDone ? Colors.green : Colors.grey,
                      ),
                      onPressed: () async {
                        ref
                            .read(todoStateProvider.notifier)
                            .toggleTodoDone(todo.id!);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.red),
                          onPressed: () {
                            showCommentPopup2(context, todo.id!);
                            titleController.clear();
                            contentController.clear();
                            (context, todo.id!);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () {
                            ref.read(todoFirebaseProvider).deleteTodo(todo.id!);
                            ref
                                .read(todoStateProvider.notifier)
                                .deleteTodo(todo.id!);
                          },
                        ),
                    ],),
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showCommentPopup1(context, todo.id!);
                        },
                        child: const Text("댓글 쓰기"),
                      ),
                      if (todo.comments != null)
                        ...todo.comments!.map((comment) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.grey[800],
                            child: ListTile(
                              title: Text(comment),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                  ref.read(todoStateProvider.notifier).deleteComment(todo.id!, comment);
                                },
                              ),
                            ),
                          );
                        }),
                    ],
                  ));
            },
          ),
        ),
      ],
    );
  }
}