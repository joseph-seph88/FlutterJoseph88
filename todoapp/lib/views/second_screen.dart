import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view_model/view_model.dart';
import 'package:todoapp/views/animation.dart';
import 'package:todoapp/views/second_screen_detail_daialog.dart';


class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ToDoViewModel provider3 = Provider.of<ToDoViewModel>(context, listen: false);

    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 80),
          Expanded(
            child: Consumer<ToDoViewModel>(
              builder: (context, provider3, child) {
                return ListView.builder(
                  itemCount: provider3.todoItems.length,
                  itemBuilder: (context, index) {
                    return AnimationBuilder(
                      content: provider3.todoItems[index],
                      onTap: () {
                        showTodoDetailDialog(context, index);
                      },
                      buttonIcon: Icons.edit_rounded,
                      index: index,
                    );
                  },
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
