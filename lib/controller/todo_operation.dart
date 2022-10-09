import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:to_do_list/utils/db_services.dart';

import '../models/todo.dart';

class TodoOperation with ChangeNotifier {
  List<ToDo> _todolist = [];

  int get todoCount {
    return _todolist.length;
  }

  int get unDoneTodoCount {
    var unDoneTodoList =
        _todolist.where((element) => element.todoDone == false);
    return unDoneTodoList.length;
  }

  UnmodifiableListView<ToDo> get todolist {
    return UnmodifiableListView(_todolist);
  }

  Future<void> setTodolist() async {
    List<ToDo> listTodo = [];
    try {
      await DBServices.dbTodos.get().then((value) {
        for (var data in value.docs) {
          listTodo.add(ToDo(
            id: data.data()['to_do_id'],
            todoName: data.data()['to_do_text'],
            priority: data.data()['to_do_prio'],
            todoDone: data.data()['to_do_done'],
          ));
        }
        _todolist = listTodo;
      });
    } catch (e) {
      print(e.toString());
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
    _todolist.sort((a, b) {
      if (a.todoDone) {
        return 1;
      } else {
        return -1;
      }
    });
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
    DBServices.dbTodos.doc(todoId).set({
      'to_do_id': todoId,
      'to_do_text': todoText,
      'to_do_prio': prio,
      'to_do_done': false,
    });
    sortTodolist();
    notifyListeners();
  }

  void doneTodo(ToDo td) {
    td.toggleDone();
    DBServices.dbTodos.doc(td.id).update({
      'to_do_done': td.todoDone,
    });
    sortTodolist();
    notifyListeners();
  }

  void updateTodo(ToDo td) {
    DBServices.dbTodos.doc(td.id).update({
      'to_do_text': td.todoName,
      'to_do_prio': td.priority,
    });
    _todolist[_todolist.indexWhere((element) => element.id == td.id)] = td;
    sortTodolist();
    notifyListeners();
  }

  void deleteTodo(ToDo td) {
    DBServices.dbTodos.doc(td.id).delete();
    _todolist.removeWhere((element) => element.id == td.id);
    sortTodolist();
    notifyListeners();
  }
}
