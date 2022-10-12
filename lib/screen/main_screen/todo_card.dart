import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/controller/todo_operation.dart';
import 'package:to_do_list/widget/edit_todo_bottom_sheet.dart';

import '../../models/todo.dart';
import '../../utils/local_notification_services.dart';
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
  final double width;
  final double height;
  final ToDo todo;
  final Function doneTd;
  const TodoCard(this.width, this.height, this.todo, this.doneTd, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: cardPadding,
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
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
                  MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: EditTodoBottomSheet(
                  todo: todo,
                ),
              );
            }),
          ),
          child: Ink(
            height: 85,
            width: 400,
            decoration: cardBoxDecorator,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: contentPadding,
                    child: CardContent(todo),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: Consumer<TodoOperation>(
                      builder: (context, todoData, child) => IconButton(
                          icon: Icon(todo.todoDone
                              ? Icons.check_circle
                              : Icons.check_circle_outline),
                          onPressed: () {
                            todoData.doneTodo(todo);
                            LocalNotificationService.setScheduledNotification(
                                context: context);
                          }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
