import 'package:class_10_firebase/todo_app/providers/todo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Popup1 extends ConsumerWidget {
  final String todoId;

  const Popup1({super.key, required this.todoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: screenWidth,
            height: screenHeight * 0.4,
            child: Material(
              color: Colors.indigo[300],
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: const Text(
                      'Todo Modify',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.indigo[400],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
                            context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[400],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ElevatedButton(
                          onPressed: () {
                            final comment = commentController.text.trim();
                            if (comment.isNotEmpty) {
                              ref
                                  .read(todoFirebaseProvider)
                                  .addComment(todoId, comment);
                              ref
                                  .read(todoStateProvider.notifier)
                                  .addComment(todoId, comment);
                              context.pop();
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('댓글을 입력해주세요.')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo[400],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 38, vertical: 15),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
