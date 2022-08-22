import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/widget/edit_todo_bottom_sheet.dart';

import '../models/todo.dart';
import 'todo_card_content.dart';

const cardPadding = EdgeInsets.all(
  10,
);
var cardBoxDecorator = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
    color: Colors.black.withAlpha(50),
  ),
);

const contentPadding = EdgeInsets.only(left: 25.0);

class TodoCard extends StatelessWidget {
  double width;
  double height;
  ToDo todo;
  Function doneTd;
  TodoCard(this.width, this.height, this.todo, this.doneTd);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: cardPadding,
      child: GestureDetector(
        onTap: () => showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          isScrollControlled: true,
          builder: ((context) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).viewInsets.left + 25,
                MediaQuery.of(context).viewInsets.top + 25,
                MediaQuery.of(context).viewInsets.right + 25,
                MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: EditTodoBottomSheet(
                todo: todo,
              ),
            );
            ;
          }),
        ),
        child: Container(
          height: 100,
          width: 400,
          decoration: cardBoxDecorator,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: contentPadding,
                  child: cardContent(todo),
                ),
              ),
              Expanded(
                child: Consumer<TodoOperation>(
                  builder: (context, todoData, child) => IconButton(
                      icon: Icon(todo.todoDone
                          ? Icons.check_circle
                          : Icons.check_circle_outline),
                      onPressed: () {
                        todoData.doneTodo(todo);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
