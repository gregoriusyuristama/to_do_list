import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/screen/register_screen.dart';

import '../widget/greetings.dart';
import '../widget/search_todo.dart';
// import '../widget/todo_container.dart';
import '../widget/todo_box.dart';
import '../widget/todo_counter.dart';

late User loggedInUser;

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  String firstName(String name) {
    List<String> nameList = name.split(" ");
    if (nameList.isNotEmpty) {
      if (nameList[0].length >= 10) {
        return nameList[0].substring(0, 10) + '...';
      }
      return nameList[0];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    final bottomPadding = EdgeInsets.only(bottom: mediaQuery.padding.bottom);
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
          bottom: false,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  child: Greetings(
                    firstName(
                      auth.currentUser!.displayName.toString(),
                    ),
                  ),
                ),
                SizedBox(
                  height: availableHeight * 0.025,
                ),
                Container(
                  height: 50,
                  child: TodoCounter(),
                ),
                // SizedBox(
                //   height: availableHeight * 0.025,
                // ),
                // SearchTodo(availableWidth * 0.85, availableHeight * 0.08),
                SizedBox(
                  height: availableHeight * 0.025,
                ),
                Expanded(
                  flex: 11,
                  child: TodoBox(bottomPadding),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
