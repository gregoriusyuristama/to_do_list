import 'package:flutter/material.dart';

import '../widget/greetings.dart';
import '../widget/search_todo.dart';
import '../widget/todo_box.dart';
import '../widget/todo_counter.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom);
    final availableWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(75, 191, 221, 1.0),
            Color.fromRGBO(138, 218, 237, 1.0),
          ],
        )),
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: SafeArea(
          child: Container(
            height: availableHeight,
            child: Column(
              children: [
                Greetings(availableWidth, availableHeight * 0.1),
                SizedBox(
                  height: availableHeight * 0.025,
                ),
                TodoCounter(availableWidth * 0.5, availableHeight * 0.05),
                SizedBox(
                  height: availableHeight * 0.025,
                ),
                SearchTodo(availableWidth * 0.85, availableHeight * 0.08),
                SizedBox(
                  height: availableHeight * 0.025,
                ),
                TodoBox(availableWidth * 0.95, availableHeight * 0.695),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
