import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

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
  late String _userEmail;
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
    _controllerPassword;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future signInWithEmailandLink(userEmail) async {
    var _userEmail = userEmail;
    return await FirebaseAuth.instance
        .sendSignInLinkToEmail(
            email: _userEmail,
            actionCodeSettings: ActionCodeSettings(
              url: "https://todoi.page.link/loginWithEmail",
              handleCodeInApp: true,
              androidPackageName: "com.byIcho.to_do_list",
              androidMinimumVersion: "1",
              iOSBundleId: 'com.byIcho.toDoi',
            ))
        .then((value) {
      print("email sent");
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        if (deepLink != null) {
          handleLink(deepLink, _controllerEmail.text);
          FirebaseDynamicLinks.instance.onLink(
              onSuccess: (PendingDynamicLinkData? dynamicLink) async {
            final Uri deepLink = dynamicLink!.link;
            handleLink(deepLink, _controllerEmail.text);
          }, onError: (OnLinkErrorException e) async {
            print(e.message);
          });
        }
      }, onError: (OnLinkErrorException e) async {
        print(e.message);
      });

      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        print(deepLink.userInfo);
      }
    } catch (e) {
      print(e);
    }
  }

  void handleLink(Uri link, userEmail) async {
    if (link != null) {
      print(userEmail);
      final UserCredential user =
          await FirebaseAuth.instance.signInWithEmailLink(
        email: userEmail,
        emailLink: link.toString(),
      );
      if (user != null) {
        print(user.credential);
        await Provider.of<TodoOperation>(context, listen: false).setTodolist();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
      }
    } else {
      print("link is null");
    }
  }

  var acs = ActionCodeSettings(
    url: 'https://todoi.page.link/loginWithEmail',
    handleCodeInApp: true,
    iOSBundleId: 'com.google.firebase.flutterauth',
    androidPackageName: 'com.google.firebase.flutterauth',
    androidInstallApp: true,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            decoration: kRegisterFieldDecoration(!_emailValidated).copyWith(
              labelText: 'E-mail',
              errorText:
                  !_emailValidated ? 'Please enter valid email address' : null,
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
          const ButtonForgotPassword(),
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
                      await Provider.of<TodoOperation>(context, listen: false)
                          .setTodolist();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ));
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
    );
  }
}
