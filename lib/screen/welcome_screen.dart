import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/screen/login_screen.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../models/todo_operation.dart';
import '../utils/authentication_exception.dart';
import '../widget/google_sign_in_button.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: kDefaultBackgroundDecoration,
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: ProgressHUD(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Column(
                      children: [
                        DefaultTextStyle(
                          style:
                              Theme.of(context).textTheme.headline1!.copyWith(
                                    fontSize: 40,
                                  ),
                          textAlign: TextAlign.center,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              WavyAnimatedText(
                                'To Do List : ToDoi',
                              ),
                            ],
                            isRepeatingAnimation: true,
                            repeatForever: true,
                          ),
                        ),
                        const Text(
                          'Manage your day',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Hero(
                    tag: 'cardContainer',
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: FutureBuilder(
                          future: Authentication.initializeFirebase(
                              context: context),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Error initializing Firebase');
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      try {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              e.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Login with Email',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: kDefaultColor,
                                      minimumSize: const Size.fromHeight(40),
                                    ),
                                  ),
                                  const GoogleSignInButton(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool _understand = false;
                                      final progress = ProgressHUD.of(context);
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                            'Warning',
                                          ),
                                          content: const Text(
                                            'When login anonymously your to do list won\'t be saved and deleted immediately after you logged out',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                return;
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: kDefaultTextColor,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _understand = true;
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Ok, i understand',
                                                style: kDefaultTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (_understand) {
                                        try {
                                          progress?.show();
                                          final _signInStatus =
                                              await Authentication
                                                  .signInAnonymousely();
                                          if (_signInStatus ==
                                              AuthStatus.successful) {
                                            await Provider.of<TodoOperation>(
                                                    context,
                                                    listen: false)
                                                .setTodolist(context: context);
                                            progress?.dismiss();
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(),
                                            ));
                                          } else {
                                            final error = AuthExceptionHandler
                                                .generateErrorMessage(
                                                    _signInStatus);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  error,
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                e.toString(),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Try with Login Anonymously',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: kDefaultColor,
                                      minimumSize: const Size.fromHeight(40),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kDefaultColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  // FutureBuilder(
                  //   future: Authentication.initializeFirebase(
                  //       context: context),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasError) {
                  //       return const Text(
                  //           'Error initializing Firebase');
                  //     } else if (snapshot.connectionState ==
                  //         ConnectionState.done) {
                  //       return const GoogleSignInButton();
                  //     }
                  //     return const CircularProgressIndicator(
                  //       valueColor: AlwaysStoppedAnimation<Color>(
                  //         kDefaultColor,
                  //       ),
                  //     );
                  //   },
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      "Don't have an account?",
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: kDefaultColor,
                      // minimumSize: Size.fromHeight(40),
                      // side: BorderSide(
                      //   color: Colors.white,
                      //   width: 1,
                      // ),
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
