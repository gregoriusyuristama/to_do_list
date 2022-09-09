import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/utils/local_notification_services.dart';
import 'package:to_do_list/widget/empty_todo.dart';

import 'add_todo_bottom_sheet.dart';
import 'bottom_button.dart';
import 'todo_card.dart';

const titleWidgetCardPadding = EdgeInsets.only(
  // top: 30.0,
  left: 30,
  right: 25,
  // bottom: 15,
);

class TodoBox extends StatelessWidget {
  const TodoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initialize();
    final todoData = Provider.of<TodoOperation>(context);
    return Container(
      decoration: kTodoBoxDecoration,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.125,
                width: constraints.maxWidth,
                padding: titleWidgetCardPadding,
                alignment: FractionalOffset.bottomLeft,
                child: Text(
                  'Your To Do Lists',
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.left,
                ),
              ),
              Divider(
                height: constraints.maxHeight * 0.025,
                thickness: 1,
              ),
              Container(
                height: constraints.maxHeight * 0.7,
                width: constraints.maxWidth,
                alignment: Alignment.center,
                child: todoData.todolist.isEmpty
                    ? EmptyTodo(
                        availableHeight: constraints.maxHeight * 0.7,
                        availableWidth: constraints.maxWidth,
                      )
                    : ListView.builder(
                        itemCount: todoData.todoCount,
                        itemBuilder: (context, index) {
                          final todoItem = todoData.todolist[index];
                          return TodoCard(
                            constraints.maxWidth,
                            constraints.maxHeight,
                            todoItem,
                            () {
                              todoData.doneTodo(todoItem);
                            },
                          );
                        },
                      ),
              ),
              Divider(
                height: constraints.maxHeight * 0.025,
                thickness: 1,
              ),
              Container(
                height: constraints.maxHeight * 0.125,
                width: constraints.maxWidth,
                padding: bottomPadding,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BottomButton(
                      FontAwesomeIcons.solidSquarePlus,
                      () => showModalBottomSheet(
                        context: context,
                        shape: kModalBotomSheetShape,
                        isScrollControlled: true,
                        builder: ((context) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).viewInsets.left + 25,
                                MediaQuery.of(context).viewInsets.top + 25,
                                MediaQuery.of(context).viewInsets.right + 25,
                                MediaQuery.of(context).viewInsets.bottom + 25,
                              ),
                              child: const AddTodoBottomSheet(),
                            ),
                          );
                        }),
                      ),
                    ),
                    // IconButton(
                    //     icon: Icon(FontAwesomeIcons.noteSticky),
                    //     onPressed: () async {
                    //       int totalTodos = todoData.unDoneTodoCount;
                    //       await LocalNotificationService.showNotification(
                    //         id: 0,
                    //         title: 'You have $totalTodos Unfinished To Do(s)',
                    //         body: 'Let\'s finish it all!',
                    //       );
                    //     }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
