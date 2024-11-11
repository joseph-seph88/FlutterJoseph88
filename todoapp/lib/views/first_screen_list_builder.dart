import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view_model/view_model.dart';
import 'package:todoapp/views/animation.dart';

class FirstScreenListBuilder extends StatelessWidget {
  const FirstScreenListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    ToDoViewModel provider3 =
        Provider.of<ToDoViewModel>(context, listen: false);

    return Expanded(
      child: Consumer<ToDoViewModel>(
        builder: (context, provider3, child) {
          return ListView.builder(
            itemCount: provider3.todoItems.length,
            itemBuilder: (context, index) {
              return AnimationBuilder(
                content: provider3.todoItems[index],
                onTap: () {
                  provider3.removeItem(index);
                },
                buttonIcon: Icons.delete,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
