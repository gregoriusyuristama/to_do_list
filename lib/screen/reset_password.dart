
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/authentication_exception.dart';

import '../utils/constants.dart';
import '../utils/validation.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _controllerEmail = TextEditingController();
  bool _emailValidated = true;
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
                      'Reset Password',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(fontSize: 40),
                      textAlign: TextAlign.left,
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
                              const SizedBox(
                                height: 15.0,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final progress = ProgressHUD.of(context);
                                  setState(() {
                                    _emailValidated = Validation.validateEmail(
                                        _controllerEmail.text);
                                  });
                                  FocusScope.of(context).unfocus();
                                  progress?.show();
                                  if (_emailValidated) {
                                    final _resetStatus =
                                        await Authentication.resetPassword(
                                            email:
                                                _controllerEmail.text.trim());
                                    if (_resetStatus == AuthStatus.successful) {
                                      progress?.dismiss();
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    } else {
                                      progress?.dismiss();
                                      final error = AuthExceptionHandler
                                          .generateErrorMessage(_resetStatus);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            error,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Reset Password',
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
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Back to Login Page',
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
