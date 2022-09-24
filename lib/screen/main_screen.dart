import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/utils/sharedpref_helper.dart';
import '../utils/string_helper.dart';
import '../widget/greetings.dart';
import '../widget/todo_box.dart';
import '../widget/todo_counter.dart';

late User loggedInUser;

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    final user = auth.currentUser;
    SharedPrefHelper.initDailyNotificationHour();
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
                user != null
                    ? Greetings(
                        StringHelper.firstName(
                          user.isAnonymous
                              ? 'Guest'
                              : user.displayName.toString(),
                        ),
                      )
                    : const Greetings(
                        'Guest',
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
                const Expanded(
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
