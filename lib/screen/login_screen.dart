import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/utils/validation.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _emailValidated = true;
  bool _passwordValidated = true;

  @override
  void dispose() {
    super.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
  }

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
          child: ProgressHUD(
            child: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              decoration:
                                  kRegisterFieldDecoration(!_emailValidated)
                                      .copyWith(
                                labelText: 'E-mail',
                                errorText: !_emailValidated
                                    ? 'Please enter valid email address'
                                    : null,
                              ),
                              style: kTextFieldTextStyle,
                              cursorColor: kDefaultColor,
                              keyboardType: TextInputType.emailAddress,
                              controller: _controllerEmail,
                              onChanged: (value) {
                                setState(() {
                                  _emailValidated =
                                      Validation.validateEmail(value);
                                });
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextField(
                              decoration:
                                  kRegisterFieldDecoration(!_passwordValidated)
                                      .copyWith(
                                labelText: 'Password',
                                errorText: !_passwordValidated
                                    ? 'Password require 6 characters'
                                    : null,
                              ),
                              style: kTextFieldTextStyle,
                              cursorColor: kDefaultColor,
                              controller: _controllerPassword,
                              obscureText: true,
                              onChanged: (value) {
                                setState(() {
                                  _passwordValidated =
                                      Validation.validatePassword(value);
                                });
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _emailValidated = Validation.validateEmail(
                                      _controllerEmail.text);
                                  _passwordValidated =
                                      Validation.validatePassword(
                                          _controllerPassword.text);
                                });
                                if (_emailValidated && _passwordValidated) {
                                  final progress = ProgressHUD.of(context);
                                  try {
                                    progress?.show();
                                    await _auth.signInWithEmailAndPassword(
                                      email: _controllerEmail.text,
                                      password: _controllerPassword.text,
                                    );

                                    await Provider.of<TodoOperation>(context,
                                            listen: false)
                                        .setTodolist(context: context);
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(
                                      builder: (context) {
                                        return MainScreen();
                                      },
                                    ));

                                    progress?.dismiss();
                                  } catch (e) {
                                    progress?.dismiss();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: kDefaultColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Back to Welcome Screen',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      style: TextButton.styleFrom(
                        primary: kDefaultColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
