import 'package:flutter/material.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

import '../widget/google_sign_in_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    final bottomPadding =
        EdgeInsets.only(bottom: mediaQuery.padding.bottom + 100);
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
          ),
        ),
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
                  child: Text(
                    'To Do List : ToDoi',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 40,
                        ),
                    textAlign: TextAlign.left,
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
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('Go To Login Page'),
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
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('Go To Sign Up Page'),
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
