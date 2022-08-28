import 'package:flutter/material.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/screen/login_screen.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../widget/google_sign_in_button.dart';

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
                        style: Theme.of(context).textTheme.headline1!.copyWith(
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
                      // Text(
                      //   'To Do List : ToDoi',
                      //   style: Theme.of(context).textTheme.headline1?.copyWith(
                      //         fontSize: 40,
                      //       ),
                      //   textAlign: TextAlign.center,
                      // ),
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
                        future:
                            Authentication.initializeFirebase(context: context),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}
