import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../../utils/authentication.dart';
import '../../utils/authentication_exception.dart';
import '../../utils/constants.dart';
import '../../utils/validation.dart';
import '../main_screen.dart';

class RegisterBox extends StatefulWidget {
  const RegisterBox({Key? key}) : super(key: key);

  @override
  State<RegisterBox> createState() => _RegisterBoxState();
}

class _RegisterBoxState extends State<RegisterBox> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerVerifyPassword =
      TextEditingController();
  bool _validateName = true;
  bool _validateEmail = true;
  bool _validatePassword = true;
  bool _validateVerifyPassword = true;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerVerifyPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: kRegisterFieldDecoration(!_validateName).copyWith(
              labelText: 'Name',
              errorText: _validateName ? null : 'Name cannot be empty',
            ),
            style: kRegisterTextStyleDecoration,
            cursorColor: kDefaultColor,
            controller: _controllerName,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextField(
            decoration: kRegisterFieldDecoration(!_validateEmail).copyWith(
              labelText: 'Email',
              errorText:
                  _validateEmail ? null : 'Please enter valid email address',
            ),
            style: kRegisterTextStyleDecoration,
            cursorColor: kDefaultColor,
            controller: _controllerEmail,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              setState(() {
                _validateEmail = Validation.validateEmail(value);
              });
            },
          ),
          const SizedBox(
            height: 15.0,
          ),
          TextField(
            decoration: kRegisterFieldDecoration(!_validatePassword).copyWith(
              labelText: 'Password',
              errorText:
                  _validatePassword ? null : 'Password require 6 characters',
            ),
            style: kRegisterTextStyleDecoration,
            cursorColor: kDefaultColor,
            controller: _controllerPassword,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _validatePassword = Validation.validatePassword(value);
              });
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration:
                kRegisterFieldDecoration(!_validateVerifyPassword).copyWith(
              labelText: 'Re-type Password',
              errorText:
                  _validateVerifyPassword ? null : 'Password is not equal',
            ),
            style: kRegisterTextStyleDecoration,
            cursorColor: kDefaultColor,
            controller: _controllerVerifyPassword,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _validateVerifyPassword = (_controllerPassword.text == value);
              });
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _validateName = _controllerName.text.isNotEmpty;
                _validateEmail =
                    Validation.validateEmail(_controllerEmail.text);
                _validatePassword =
                    Validation.validatePassword(_controllerPassword.text);
                _validateVerifyPassword = (_controllerPassword.text ==
                    _controllerVerifyPassword.text);
              });
              final progress = ProgressHUD.of(context);
              FocusScope.of(context).unfocus();
              progress?.show();
              if (_validateName &&
                  _validateEmail &&
                  _validatePassword &&
                  _validateVerifyPassword) {
                final statusCreateAccount = await Authentication.createAccount(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text,
                    name: _controllerName.text);
                if (statusCreateAccount == AuthStatus.successful) {
                  progress?.dismiss();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                } else {
                  progress?.dismiss();
                  final error = AuthExceptionHandler.generateErrorMessage(
                      statusCreateAccount);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error.toString(),
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
              'Register',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
