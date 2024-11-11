import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/screens/todo_screen_02.dart';
import 'package:todoapp/view/view_model.dart';

class TodoScreen01 extends StatelessWidget {
  TodoScreen01({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<ToDoViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY TODO LIST'),
      ),
      body: PageView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter Text',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      todoProvider.addItem(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Consumer<ToDoViewModel>(
                    builder: (context, todoProvider, child) {
                      return ListView.builder(
                          itemCount: todoProvider.todoItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(todoProvider.todoItems[index]),
                                trailing: IconButton(
                                  onPressed: () {
                                    todoProvider.removeItem(index);
                                  },
                                  icon: const Icon(Icons.remove),
                                ));
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
          const TodoScreen02(),
        ],
      ),
    );
  }
}
