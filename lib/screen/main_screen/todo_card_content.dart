import 'package:flutter/material.dart';
import 'package:to_do_list/utils/string_helper.dart';

import '../../models/todo.dart';

class CardContent extends StatelessWidget {
  const CardContent(this.todo, {Key? key}) : super(key: key);

  final ToDo todo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(
          height: 5,
        ),
        todo.hasDueDate()
            ? Container(
                width: 210,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  // color: kDefaultColor,
                ),
                child: FittedBox(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          StringHelper.formatDueDate(todo.dueDate),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
