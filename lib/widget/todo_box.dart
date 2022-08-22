import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:to_do_list/widget/empty_todo.dart';

import 'add_todo_bottom_sheet.dart';
import 'bottom_button.dart';
import 'todo_card.dart';

const titleBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  ),
  color: Color.fromRGBO(247, 251, 255, 1.0),
);
const titleWidgetCardPadding = EdgeInsets.only(
  // top: 30.0,
  left: 30,
  right: 25,
  // bottom: 15,
);

class TodoBox extends StatelessWidget {
  final bottomPadding;

  TodoBox(this.bottomPadding);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoOperation>(builder: (context, todoData, child) {
      return Container(
        decoration: titleBoxDecoration,
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
                      ? EmptyTodo()
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
                      bottomButton(
                        FontAwesomeIcons.solidSquarePlus,
                        () => showModalBottomSheet(
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
                              child: AddTodoBottomSheet(),
                            );
                            ;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
