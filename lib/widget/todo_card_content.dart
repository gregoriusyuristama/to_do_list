import 'package:flutter/material.dart';

import '../models/todo.dart';

class CardContent extends StatelessWidget {
  CardContent(this.todo);

  final ToDo todo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          todo.todoName,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
              decoration: todo.todoDone ? TextDecoration.lineThrough : null,
              color: todo.todoDone ? Colors.red : null),
        ),
        Text(
          'Priority : ${todo.priority.toString()}',
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
