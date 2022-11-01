// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/todo_operation.dart';
import '../utils/authentication.dart';
import '../utils/authentication_exception.dart';
import '../utils/constants.dart';
import '../utils/validation.dart';
import '../screen/main_screen/main_screen.dart';
import 'button_forgot_password.dart';

class LoginBox extends StatefulWidget {
  const LoginBox({Key? key}) : super(key: key);

  @override
  State<LoginBox> createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> with WidgetsBindingObserver {
  bool _emailValidated = true;
  bool _passwordValidated = true;
  bool _loginWithLink = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future signInWithEmailandLink(userEmail) async {
    return await FirebaseAuth.instance
        .sendSignInLinkToEmail(
            email: userEmail,
            actionCodeSettings: ActionCodeSettings(
              url: "https://todoi.page.link/loginWithEmail",
              handleCodeInApp: true,
              androidPackageName: "com.byIcho.to_do_list",
              androidMinimumVersion: "1",
              iOSBundleId: 'com.byIcho.toDoi',
            ))
        .then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('emailSignIn', userEmail);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Link Sent',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Sign in Link has been sent to : ${_controllerEmail.text}\nPlease check your spam folder if no email received',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('OK', style: kDefaultTextColor),
            ),
          ],
        ),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('emailSignIn');
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          Authentication.handleSignInLink(deepLink, userEmail, context);
          FirebaseDynamicLinks.instance.onLink(
              onSuccess: (PendingDynamicLinkData? dynamicLink) async {
            final Uri deepLink = dynamicLink!.link;
            Authentication.handleSignInLink(deepLink, userEmail, context);
          }, onError: (OnLinkErrorException e) async {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.message.toString(),
                ),
              ),
            );
          });
        }
      }, onError: (OnLinkErrorException e) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message.toString(),
            ),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.fastOutSlowIn,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: kRegisterFieldDecoration(!_emailValidated).copyWith(
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
                  _emailValidated = Validation.validateEmail(value);
                });
              },
            ),
            Visibility(
              visible: !_loginWithLink,
              child: const SizedBox(
                height: 15.0,
              ),
            ),
            Visibility(
              visible: !_loginWithLink,
              child: TextField(
                decoration:
                    kRegisterFieldDecoration(!_passwordValidated).copyWith(
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
                    _passwordValidated = Validation.validatePassword(value);
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _loginWithLink = !_loginWithLink;
                });
              },
              child: Text(
                !_loginWithLink
                    ? 'Login With Email Link'
                    : 'Login With Email and Password',
                style: const TextStyle(
                  color: kDefaultColor,
                ),
              ),
            ),
            Visibility(
              visible: !_loginWithLink,
              child: const ButtonForgotPassword(),
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 15,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  if (_loginWithLink) {
                    signInWithEmailandLink(_controllerEmail.text);
                  } else {
                    FocusScope.of(context).unfocus();
                    final progress = ProgressHUD.of(context);
                    setState(() {
                      _emailValidated =
                          Validation.validateEmail(_controllerEmail.text);
                      _passwordValidated =
                          Validation.validatePassword(_controllerPassword.text);
                    });
                    progress?.show();
                    if (_emailValidated && _passwordValidated) {
                      final signInStatus = await Authentication.signInWithEmail(
                          email: _controllerEmail.text.trim(),
                          password: _controllerPassword.text);
                      if (signInStatus == AuthStatus.successful) {
                        if (FirebaseAuth.instance.currentUser!.emailVerified) {
                          await Provider.of<TodoOperation>(context,
                                  listen: false)
                              .setTodolist();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Navigator.pushReplacementNamed(
                              context, MainScreen.id);
                        } else {
                          await FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                'Verify your Email',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Verify Link has been sent to : ${FirebaseAuth.instance.currentUser!.email.toString()}\nPlease check your spam folder if no email received',
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                                  child: const Text('OK',
                                      style: kDefaultTextColor),
                                ),
                              ],
                            ),
                          );
                        }

                        progress?.dismiss();
                      } else {
                        progress?.dismiss();
                        final error = AuthExceptionHandler.generateErrorMessage(
                            signInStatus);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              error,
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDefaultColor,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
