import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/utils/sharedpref_helper.dart';
import 'package:to_do_list/utils/string_helper.dart';
import 'package:to_do_list/widget/greetings.dart';

import '../models/todo_operation.dart';
import '../utils/local_notification_services.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Container(
          height: mediaQuery.height,
          width: mediaQuery.width,
          decoration: kDefaultBackgroundDecoration,
          child: SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: mediaQuery.width * 0.025),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Greetings(
                    user!.isAnonymous
                        ? 'Guest'
                        : StringHelper.firstName(user.displayName.toString()),
                  ),
                  Expanded(
                    child: Container(
                      decoration: kTodoBoxDecoration,
                      width: mediaQuery.width,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: SizedBox(
                                  height: constraints.maxHeight * 0.08,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: constraints.maxWidth * 0.1,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: Icon(
                                            Icons.arrow_back,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: constraints.maxWidth * 0.05,
                                      ),
                                      Container(
                                        width: constraints.maxWidth * 0.75,
                                        alignment: FractionalOffset.centerLeft,
                                        child: Text(
                                          'Settings',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: Text(
                                  'Notification',
                                  style: kDefaultTextColor.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(
                                height: constraints.maxHeight * 0.025,
                                thickness: 1,
                                color: kDefaultColor,
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: TextButton(
                                  onPressed: () async {
                                    var currentDailyHour =
                                        await SharedPrefHelper
                                            .getDailyNotificationHour();
                                    var currentDailyMinutes =
                                        await SharedPrefHelper
                                            .getDailyNotificationMinutes();
                                    TimeOfDay time = TimeOfDay(
                                        hour: currentDailyHour,
                                        minute: currentDailyMinutes);
                                    TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: time,
                                    );
                                    if (newTime != null) {
                                      SharedPrefHelper
                                          .changeDailyNotificationHour(
                                        newTime.hour,
                                        newTime.minute,
                                      );
                                      LocalNotificationService
                                          .setScheduledNotification(
                                        context: context,
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Change Daily Notification Time',
                                        style: kDefaultTextColor,
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          color: kDefaultColor),
                                    ],
                                  ),
                                  style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft),
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth,
                                child: Text(
                                  'Account',
                                  style: TextStyle(
                                    color: Colors.red[300],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(
                                height: constraints.maxHeight * 0.025,
                                thickness: 1,
                                color: Colors.red[300],
                              ),
                              TextButton(
                                onPressed: () {
                                  Authentication.confirmationDialog(
                                    context: context,
                                    confirmationText: 'Do you want to log out?',
                                  ).then((confirmed) {
                                    if (confirmed) {
                                      Authentication.signOut(context: context);
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Sign Out',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.red[300],
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Authentication.confirmationDialog(
                                    context: context,
                                    confirmationText:
                                        'Are you sure do you want to delete you account?',
                                  ).then((confirmed) {
                                    if (confirmed) {
                                      Authentication.deleteAccount(
                                          context: context);
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Delete Account',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.red[300],
                                    ),
                                  ],
                                ),
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
