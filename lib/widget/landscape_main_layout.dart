// ignore_for_file: sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/screen/app_settings.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/widget/counter_finished.dart';
import 'package:to_do_list/widget/todo_box.dart';

import '../utils/string_helper.dart';

class LandscapeMainLayout extends StatelessWidget {
  const LandscapeMainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    double unitWidthValue = MediaQuery.of(context).size.width * 0.01;
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color.fromRGBO(75, 191, 221, 0.7),
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(25, unitHeightValue * 10, 50, 10),
                      child: Text(
                        'Hi, ${StringHelper.firstName(user!.isAnonymous ? 'Guest' : user.displayName.toString())}',
                        style: Theme.of(context)
                            .textTheme
                            .headline1
                            ?.copyWith(fontSize: unitWidthValue * 4.5),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Align(
                            child: Column(
                              children: const [
                                CounterLandscape(true),
                                SizedBox(
                                  height: 25,
                                ),
                                CounterLandscape(false),
                              ],
                            ),
                            alignment: FractionalOffset.topLeft,
                          ),
                          flex: 1,
                        ),
                        TextButton(
                          child: const Text(
                            'Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, AppSettings.id),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextButton(
                          child: const Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () => {
                            Authentication.confirmationDialog(
                              context: context,
                              confirmationText: 'Do you want to log out?',
                            ).then((confirmed) {
                              if (confirmed) {
                                Authentication.signOut(context: context);
                              }
                            })
                          },
                        ),
                      ],
                    ),
                  ),
                  flex: 4,
                ),
              ],
            ),
            color: const Color.fromRGBO(255, 255, 255, 0.2),
          ),
          flex: 1,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(unitWidthValue * 9, 50, 0, 50),
            child: const TodoBox(true),
          ),
          flex: 2,
        ),
      ],
    );
  }
}
