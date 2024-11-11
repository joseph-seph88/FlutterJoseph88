import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view_model/view_model.dart';
import 'package:todoapp/views/second_screen_detail_card.dart';


void showTodoDetailDialog(BuildContext context, int index) {
  final TextEditingController todoController = TextEditingController();
  final TextEditingController subItemController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  final todoViewModel = Provider.of<ToDoViewModel>(context, listen: false);
  todoController.text = todoViewModel.todoItems[index];
  subItemController.text = todoViewModel.subItems[index];
  detailController.text = todoViewModel.details[index];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('TO DO DETAIL', style: TextStyle(color: Colors.deepPurple)),
        content: SizedBox(
          height: 400,
          width: 400,
          child: Column(
            children: [
              SecondScreenDetailCard(
                controller: todoController,
                label: 'Main',
              ),
              SecondScreenDetailCard(
                controller: subItemController,
                label: 'Sub',
              ),
              SecondScreenDetailCard(
                controller: detailController,
                label: 'Detail',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (todoController.text.isNotEmpty &&
                          subItemController.text.isNotEmpty &&
                          detailController.text.isNotEmpty) {
                        todoViewModel.updateItem(
                          index,
                          todoController.text,
                          subItemController.text,
                          detailController.text,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.save_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}