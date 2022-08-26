import 'package:flutter/material.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/screen/login_screen.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

import '../widget/google_sign_in_button.dart';

class WelcomeScreen extends StatelessWidget {
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
                      Text(
                        'To Do List : ToDoi',
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 40,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Manage your day',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
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
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kDefaultColor,
                            minimumSize: Size.fromHeight(40),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            try {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
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
                          child: FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
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
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: kDefaultColor,
                            minimumSize: Size.fromHeight(40),
                          ),
                        ),
                        FutureBuilder(
                          future: Authentication.initializeFirebase(
                              context: context),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error initializing Firebase');
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return GoogleSignInButton();
                            }
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lightBlue),
                            );
                          },
                        ),
                      ],
                    ),
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
