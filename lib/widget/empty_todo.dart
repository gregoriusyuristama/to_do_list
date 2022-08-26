import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyTodo extends StatelessWidget {
  double availableHeight;
  double availableWidth;

  EmptyTodo({required this.availableWidth, required this.availableHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: availableHeight,
      width: availableWidth,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              child: Icon(
                FontAwesomeIcons.noteSticky,
                color: Colors.grey[400],
                size: 100,
              ),
            ),
            Text(
              'Your To Do List is Empty\nLet\'s Create New To Do !',
              style: TextStyle(color: Colors.grey, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
