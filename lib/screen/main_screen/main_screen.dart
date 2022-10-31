import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:to_do_list/screen/main_screen/search_todo.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/utils/sharedpref_helper.dart';
import '../../utils/local_notification_services.dart';
import '../../utils/string_helper.dart';
import '../../widget/greetings.dart';
import 'todo_box.dart';
import 'todo_counter.dart';

late User loggedInUser;

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    final user = auth.currentUser;
    SharedPrefHelper.initDailyNotificationHour();
    LocalNotificationService.initialize();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: kDefaultBackgroundDecoration,
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.size.width * 0.025,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: availableHeight * 0.08,
                  child: Greetings(
                    StringHelper.firstName(
                      user!.isAnonymous ? 'Guest' : user.displayName.toString(),
                    ),
                    true,
                  ),
                ),
                SizedBox(
                  height: availableHeight * 0.01,
                ),
                SizedBox(
                  height: availableHeight * 0.055,
                  child: const TodoCounter(),
                ),
                SizedBox(
                  height: availableHeight * 0.055,
                  child: Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text(
                        StringHelper.formatDate(
                          DateTime.now(),
                        ),
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: SearchTodo(
                //       mediaQuery.size.width * 0.9, availableHeight * 0.05),
                // ),
                // SizedBox(
                //   height: availableHeight * 0.025,
                // ),
                SizedBox(
                  height: availableHeight * 0.8,
                  width: mediaQuery.size.width,
                  child: const TodoBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
