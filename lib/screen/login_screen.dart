import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    final bottomPadding =
        EdgeInsets.only(bottom: mediaQuery.padding.bottom + 100);
    final availableWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.left,
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            decoration: kRegisterFieldDecoration.copyWith(
                                labelText: 'E-mail'),
                            style: TextStyle(
                              color: kDefaultColor,
                              fontWeight: FontWeight.normal,
                            ),
                            cursorColor: kDefaultColor,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => email = value,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            decoration: kRegisterFieldDecoration.copyWith(
                                labelText: 'Password'),
                            style: TextStyle(
                              color: kDefaultColor,
                              fontWeight: FontWeight.normal,
                            ),
                            cursorColor: kDefaultColor,
                            onChanged: (value) => password = value,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                setState(() {
                                  showSpinner = true;
                                });
                                final user = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );
                                if (user != null) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(),
                                      ));
                                }
                                showSpinner = false;
                              } catch (e) {
                                showSpinner = false;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text('Login'),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromRGBO(75, 191, 221, 1.0),
                            ),
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
      ),
    );
  }
}
