import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:to_do_list/utils/db_services.dart';

import '../models/todo.dart';
import '../utils/local_notification_services.dart';

class TodoOperation with ChangeNotifier {
  List<ToDo> _todolist = [];

  int get todoCount {
    return _todolist.length;
  }

  int get unFinishedTodoCount {
    var unDoneTodoList =
        _todolist.where((element) => element.todoDone == false);
    return unDoneTodoList.length;
  }

  int get finishedTodoCount {
    var unDoneTodoList = _todolist.where((element) => element.todoDone == true);
    return unDoneTodoList.length;
  }

  UnmodifiableListView<ToDo> get todolist {
    return UnmodifiableListView(_todolist);
  }

  UnmodifiableListView<ToDo> get finishedTodolist {
    return UnmodifiableListView(
        _todolist.where((todo) => todo.todoDone == true));
  }

  UnmodifiableListView<ToDo> get unfinishedTodolist {
    return UnmodifiableListView(
        _todolist.where((todo) => todo.todoDone == false));
  }

  Future<void> setTodolist() async {
    List<ToDo> listTodo = [];
    try {
      await DBServices.getDbTodos().get().then((value) {
        for (var data in value.docs) {
          if (data.data().containsKey('to_do_date')) {
            listTodo.add(ToDo(
              id: data.data()['to_do_id'],
              todoName: data.data()['to_do_text'],
              priority: data.data()['to_do_prio'],
              todoDone: data.data()['to_do_done'],
              dueDate: data.data()['to_do_date'],
            ));
          } else {
            listTodo.add(ToDo(
              id: data.data()['to_do_id'],
              todoName: data.data()['to_do_text'],
              priority: data.data()['to_do_prio'],
              todoDone: data.data()['to_do_done'],
            ));
          }
        }
        _todolist = listTodo;
      });
    } catch (e) {
      SnackBar(
          content: Text(
        e.toString(),
      ));
    }
    sortTodolist();
    notifyListeners();
  }

  void clearTodoList() {
    _todolist = [];
    notifyListeners();
  }

  void sortTodolist() {
    _todolist.sort(
      (a, b) => b.priority.compareTo(a.priority),
    );
  }

  void addTodo(String todoText, int prio) {
    String todoId = DateTime.now().toString();
    _todolist.add(
      ToDo(
        id: todoId,
        todoName: todoText,
        priority: prio,
      ),
    );
    DBServices.getDbTodos().doc(todoId).set({
      'to_do_id': todoId,
      'to_do_text': todoText,
      'to_do_prio': prio,
      'to_do_done': false,
    });
    sortTodolist();
    notifyListeners();
  }

  void addTodoWithDate(
      String todoText, int prio, String dueDate, BuildContext context) {
    String todoId = DateTime.now().toString();
    ToDo td = ToDo(
      id: todoId,
      todoName: todoText,
      priority: prio,
      dueDate: dueDate,
    );
    _todolist.add(td);
    DBServices.getDbTodos().doc(todoId).set({
      'to_do_id': todoId,
      'to_do_text': todoText,
      'to_do_prio': prio,
      'to_do_done': false,
      'to_do_date': dueDate,
    });
    LocalNotificationService.setDueDateNotification(context: context, td: td);
    sortTodolist();
    notifyListeners();
  }

  void doneTodo(ToDo td) {
    td.toggleDone();
    DBServices.getDbTodos().doc(td.id).update({
      'to_do_done': td.todoDone,
    });
    sortTodolist();
    notifyListeners();
  }

  void updateTodo(ToDo td) {
    DBServices.getDbTodos().doc(td.id).update({
      'to_do_text': td.todoName,
      'to_do_prio': td.priority,
    });
    _todolist[_todolist.indexWhere((element) => element.id == td.id)] = td;
    sortTodolist();
    notifyListeners();
  }

  void updateTodoWithDate(ToDo td) {
    DBServices.getDbTodos().doc(td.id).update({
      'to_do_text': td.todoName,
      'to_do_prio': td.priority,
      'to_do_date': td.dueDate,
    });
    _todolist[_todolist.indexWhere((element) => element.id == td.id)] = td;
    sortTodolist();
    notifyListeners();
  }

  void deleteTodo(ToDo td) {
    DBServices.getDbTodos().doc(td.id).delete();
    _todolist.removeWhere((element) => element.id == td.id);
    sortTodolist();
    notifyListeners();
  }

  @override
  void dispose() {
    _todolist = [];
    super.dispose();
  }
}
