import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view/view_model.dart';

class TodoScreen02 extends StatelessWidget {
  const TodoScreen02({super.key});

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<ToDoViewModel>(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Expanded(
              child: ListView.builder(
                  itemCount: todoProvider.todoItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(todoProvider.todoItems[index]),
                      trailing: IconButton(
                          onPressed: () {
                            todoProvider.removeItem(index);
                          },
                          icon: const Icon(Icons.remove)),
                      onTap: () {},
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
