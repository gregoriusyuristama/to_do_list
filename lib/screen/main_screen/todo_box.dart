import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/controller/todo_operation.dart';
import 'package:to_do_list/widget/empty_todo.dart';

import '../../widget/add_todo_bottom_sheet.dart';
import '../../widget/bottom_button.dart';
import 'todo_card.dart';

class TodoBox extends StatefulWidget {
  const TodoBox({Key? key}) : super(key: key);

  @override
  State<TodoBox> createState() => _TodoBoxState();
}

class _TodoBoxState extends State<TodoBox> {
  bool showUnfinished = true;
  User? loggedInUser = FirebaseAuth.instance.currentUser;
  late TodoOperation _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<TodoOperation>(context);
    return Container(
      decoration: kTodoBoxDecoration,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                height: constraints.maxHeight * 0.125,
                width: constraints.maxWidth,
                padding: kTitleWidgetCardPadding,
                alignment: FractionalOffset.centerLeft,
                child: const FittedBox(
                  child: Text(
                    'Your To Do List',
                    style: kTitleToDoBox,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Divider(
                height: constraints.maxHeight * 0.025,
                thickness: 1,
              ),
              AnimatedSize(
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.fastOutSlowIn,
                child: showUnfinished
                    ? Container(
                        height: constraints.maxHeight * 0.675,
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        child: _bloc.unfinishedTodolist.isEmpty
                            ? EmptyTodo(
                                availableHeight: constraints.maxHeight * 0.65,
                                availableWidth: constraints.maxWidth,
                              )
                            : ListView.builder(
                                itemCount: _bloc.unfinishedTodolist.length,
                                itemBuilder: (context, index) {
                                  final todoItem =
                                      _bloc.unfinishedTodolist[index];
                                  return TodoCard(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                    todoItem,
                                    () {
                                      _bloc.doneTodo(todoItem);
                                    },
                                  );
                                },
                              ),
                      )
                    : SizedBox(
                        width: constraints.maxWidth,
                      ),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showUnfinished = !showUnfinished;
                    });
                  },
                  child: Container(
                    height: constraints.maxHeight * 0.07,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<TodoOperation>(
                          builder: (context, todoData, child) => Text(
                            'Finished (${todoData.finishedTodoCount})',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          showUnfinished
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.fastOutSlowIn,
                child: !showUnfinished
                    ? Container(
                        height: constraints.maxHeight * 0.675,
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        child: _bloc.finishedTodolist.isEmpty
                            ? EmptyTodo(
                                availableHeight: constraints.maxHeight * 0.65,
                                availableWidth: constraints.maxWidth,
                              )
                            : ListView.builder(
                                itemCount: _bloc.finishedTodoCount,
                                itemBuilder: (context, index) {
                                  final todoItem =
                                      _bloc.finishedTodolist[index];
                                  return TodoCard(
                                    constraints.maxWidth,
                                    constraints.maxHeight,
                                    todoItem,
                                    () {
                                      _bloc.doneTodo(todoItem);
                                    },
                                  );
                                },
                              ),
                      )
                    : SizedBox(
                        width: constraints.maxWidth,
                      ),
              ),
              Divider(
                height: constraints.maxHeight * 0.005,
                thickness: 1,
              ),
              Container(
                height: constraints.maxHeight * 0.1,
                width: constraints.maxWidth,
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
