import 'dart:collection';

import 'package:flutter/material.dart';

import 'todo.dart';

class TodoOperation with ChangeNotifier {
  List<ToDo> _todolist = [
    // ToDo(id: 't1', todoName: "Doing Homework", priority: 4, todoDone: true),
    // ToDo(id: 't2', todoName: "Learn Programming", priority: 3, todoDone: false),
    // ToDo(id: 't3', todoName: "Watch Films", priority: 2, todoDone: true),
    // ToDo(id: 't4', todoName: "Workout", priority: 5, todoDone: true),
    // ToDo(id: 't5', todoName: "Read Books", priority: 1, todoDone: false),
  ];

  int get todoCount {
    return _todolist.length;
  }

  UnmodifiableListView<ToDo> get todolist {
    return UnmodifiableListView(_todolist);
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
    _todolist.add(
      ToDo(
        id: DateTime.now().toString(),
        todoName: todoText,
        priority: prio,
      ),
    );
    sortTodolist();
    notifyListeners();
  }

  void doneTodo(ToDo td) {
    td.toggleDone();
    sortTodolist();
    notifyListeners();
  }

  void updateTodo(ToDo td) {
    _todolist[_todolist.indexWhere((element) => element.id == td.id)] = td;
    sortTodolist();
    notifyListeners();
  }

  void deleteTodo(ToDo td) {
    _todolist.removeWhere((element) => element.id == td.id);
    sortTodolist();
    notifyListeners();
  }
}
