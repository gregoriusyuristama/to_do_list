import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../controller/todo_operation.dart';
import '../../utils/authentication.dart';
import '../../utils/authentication_exception.dart';
import '../../utils/constants.dart';
import '../../utils/validation.dart';
import '../main_screen.dart';
import 'button_forgot_password.dart';

class LoginBox extends StatefulWidget {
  const LoginBox({Key? key}) : super(key: key);

  @override
  State<LoginBox> createState() => _LoginBoxState();
}

class _LoginBoxState extends State<LoginBox> {
  bool _emailValidated = true;
  bool _passwordValidated = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword;
    super.dispose();
  }

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
          const SizedBox(
            height: 15.0,
          ),
          TextField(
            decoration: kRegisterFieldDecoration(!_passwordValidated).copyWith(
              labelText: 'Password',
              errorText:
                  !_passwordValidated ? 'Password require 6 characters' : null,
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
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () async {
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
                  final error =
                      AuthExceptionHandler.generateErrorMessage(signInStatus);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error,
                      ),
                    ),
                  );
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
          const ButtonForgotPassword(),
        ],
      ),
    );
  }
}
