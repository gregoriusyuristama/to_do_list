import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/screen/reset_password.dart';
import 'package:to_do_list/utils/authentication.dart';
import 'package:to_do_list/utils/authentication_exception.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/utils/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _emailValidated = true;
  bool _passwordValidated = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
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
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headline1,
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
                              padding: const EdgeInsets.only(
                                left: 25.0,
                                right: 25.0,
                                top: 25.0,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextField(
                                      decoration: kRegisterFieldDecoration(
                                              !_emailValidated)
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
                                    TextField(
                                      decoration: kRegisterFieldDecoration(
                                              !_passwordValidated)
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
                                              Validation.validatePassword(
                                                  value);
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();
                                        final progress =
                                            ProgressHUD.of(context);
                                        setState(() {
                                          _emailValidated =
                                              Validation.validateEmail(
                                                  _controllerEmail.text);
                                          _passwordValidated =
                                              Validation.validatePassword(
                                                  _controllerPassword.text);
                                        });
                                        progress?.show();
                                        if (_emailValidated &&
                                            _passwordValidated) {
                                          final _signInStatus =
                                              await Authentication
                                                  .signInWithEmail(
                                                      email:
                                                          _controllerEmail
                                                              .text
                                                              .trim(),
                                                      password:
                                                          _controllerPassword
                                                              .text);
                                          if (_signInStatus ==
                                              AuthStatus.successful) {
                                            await Provider.of<TodoOperation>(
                                                    context,
                                                    listen: false)
                                                .setTodolist(context: context);
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(),
                                            ));
                                            progress?.dismiss();
                                          } else {
                                            progress?.dismiss();
                                            final error = AuthExceptionHandler
                                                .generateErrorMessage(
                                                    _signInStatus);
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
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: kDefaultColor,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ResetPassword(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          color: kDefaultColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
