import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyTodo extends StatelessWidget {
  const EmptyTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.noteSticky,
            color: Colors.grey[400],
            size: 100,
          ),
          Text(
            'Your To Do List is Empty\nLet\'s Create New To Do !',
            style: TextStyle(color: Colors.grey, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
