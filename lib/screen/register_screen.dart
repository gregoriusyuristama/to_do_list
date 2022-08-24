import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

import '../widget/google_sign_in_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String name;
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
            ),
          ),
          width: mediaQuery.size.width,
          height: mediaQuery.size.height,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Registration',
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
                                labelText: 'Name'),
                            style: kRegisterTextStyleDecoration,
                            cursorColor: kDefaultColor,
                            onChanged: (value) => name = value,
                            keyboardType: TextInputType.name,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            decoration: kRegisterFieldDecoration.copyWith(
                                labelText: 'Email'),
                            style: kRegisterTextStyleDecoration,
                            cursorColor: kDefaultColor,
                            onChanged: (value) => email = value,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            decoration: kRegisterFieldDecoration.copyWith(
                                labelText: 'Password'),
                            style: kRegisterTextStyleDecoration,
                            cursorColor: kDefaultColor,
                            onChanged: (value) => password = value,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                final result =
                                    await _auth.createUserWithEmailAndPassword(
                                        email: email, password: password);
                                User? user = result.user;
                                await user?.updateDisplayName(name);

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                                setState(() {
                                  showSpinner = false;
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text('Register'),
                            style: ElevatedButton.styleFrom(
                              primary: kDefaultColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
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
