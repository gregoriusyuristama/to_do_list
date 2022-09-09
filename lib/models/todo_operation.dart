import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'todo.dart';

class TodoOperation with ChangeNotifier {
  List<ToDo> _todolist = [];

  // final db = FirebaseFirestore.instance
  //     .collection('user')
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .collection('to_dos');

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

  Future<void> setTodolist({required BuildContext context}) async {
    List<ToDo> listTodo = [];
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser!.uid)
          .collection('to_dos')
          .get()
          .then((value) {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
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
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('to_dos')
        .doc(todoId)
        .set({
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
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('to_dos')
        .doc(td.id)
        .update({
      'to_do_done': td.todoDone,
    });
    sortTodolist();
    notifyListeners();
  }

  void updateTodo(ToDo td) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('to_dos')
        .doc(td.id)
        .update({
      'to_do_text': td.todoName,
      'to_do_prio': td.priority,
    });
    _todolist[_todolist.indexWhere((element) => element.id == td.id)] = td;
    sortTodolist();
    notifyListeners();
  }

  void deleteTodo(ToDo td) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('to_dos')
        .doc(td.id)
        .delete();
    _todolist.removeWhere((element) => element.id == td.id);
    sortTodolist();
    notifyListeners();
  }
}
