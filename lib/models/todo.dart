import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final List<String> todoItems;

  const Todo(this.todoItems);

  Todo copyWith({List<String>? todoItems}) {
    return Todo(todoItems ?? this.todoItems);
  }

  @override
  List<Object?> get props => [todoItems];
}
