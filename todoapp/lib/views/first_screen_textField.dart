import 'package:flutter/material.dart';
import 'package:todoapp/view_model/view_model.dart';
import 'package:provider/provider.dart';

class FirstScreenTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  FirstScreenTextField({super.key});

  @override
  Widget build(BuildContext context) {
    ToDoViewModel provider3 =
        Provider.of<ToDoViewModel>(context, listen: false);

    return SizedBox(
      width: 380,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: 'To Do List',
          suffixIcon: IconButton(
            onPressed: () {
              _controller.clear();
              FocusScope.of(context).unfocus();
            },
            icon: const Icon(Icons.clear),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.deepPurple,
              width: 2,
            ),
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            provider3.addItem(value);
            _controller.clear();
          }
        },
      ),
    );
  }
}
