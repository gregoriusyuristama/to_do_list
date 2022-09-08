import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/constants.dart';
import '../utils/local_notification_services.dart';
import '../widget/greetings.dart';
import '../widget/todo_box.dart';
import '../widget/todo_counter.dart';

late User loggedInUser;

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  String firstName(String name) {
    List<String> nameList = name.split(" ");
    if (nameList.isNotEmpty) {
      if (nameList[0].length >= 10) {
        return '${nameList[0].substring(0, 10)}...';
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
    final user = auth.currentUser;

    LocalNotificationService.initialize();
    int totalTodos = Provider.of<TodoOperation>(context).unDoneTodoCount;
    LocalNotificationService.showScheduledNotification(
        id: 0,
        title: 'You have $totalTodos Unfinished To Do(s)',
        body: 'Let\'s finish it all!',
        hour: 8);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: kDefaultBackgroundDecoration,
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
                SizedBox(
                  height: 100,
                  child: user != null
                      ? Greetings(
                          firstName(
                            user.isAnonymous
                                ? 'Guest'
                                : user.displayName.toString(),
                          ),
                        )
                      : Greetings(
                          '-',
                        ),
                ),
                SizedBox(
                  height: availableHeight * 0.025,
                ),
                const SizedBox(
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
                  child: TodoBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
