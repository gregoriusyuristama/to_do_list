import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/utils/validation.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
    _controllerName.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ProgressHUD(
        child: Builder(builder: (context) {
          return Container(
            decoration: kDefaultBackgroundDecoration,
            width: mediaQuery.size.width,
            height: mediaQuery.size.height,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(25.0),
                alignment: Alignment.center,
                child: SingleChildScrollView(
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
                                decoration:
                                    kRegisterFieldDecoration(!_validateName)
                                        .copyWith(
                                  labelText: 'Name',
                                  errorText: _validateName
                                      ? null
                                      : 'Name cannot be empty',
                                ),
                                style: kRegisterTextStyleDecoration,
                                cursorColor: kDefaultColor,
                                controller: _controllerName,
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextField(
                                decoration:
                                    kRegisterFieldDecoration(!_validateEmail)
                                        .copyWith(
                                  labelText: 'Email',
                                  errorText: _validateEmail
                                      ? null
                                      : 'Please enter valid email address',
                                ),
                                style: kRegisterTextStyleDecoration,
                                cursorColor: kDefaultColor,
                                controller: _controllerEmail,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  setState(() {
                                    _validateEmail =
                                        Validation.validateEmail(value);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextField(
                                decoration:
                                    kRegisterFieldDecoration(!_validatePassword)
                                        .copyWith(
                                  labelText: 'Password',
                                  errorText: _validatePassword
                                      ? null
                                      : 'Password require 6 characters',
                                ),
                                style: kRegisterTextStyleDecoration,
                                cursorColor: kDefaultColor,
                                controller: _controllerPassword,
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    _validatePassword =
                                        Validation.validatePassword(value);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextField(
                                decoration: kRegisterFieldDecoration(
                                        !_validateVerifyPassword)
                                    .copyWith(
                                  labelText: 'Verify Password',
                                  errorText: _validateVerifyPassword
                                      ? null
                                      : 'Password is not equal',
                                ),
                                style: kRegisterTextStyleDecoration,
                                cursorColor: kDefaultColor,
                                controller: _controllerVerifyPassword,
                                obscureText: true,
                                onChanged: (value) {
                                  setState(() {
                                    _validateVerifyPassword =
                                        (_controllerPassword.text == value);
                                  });
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _validateName =
                                        _controllerName.text.isNotEmpty;
                                    _validateEmail = Validation.validateEmail(
                                        _controllerEmail.text);
                                    _validatePassword =
                                        Validation.validatePassword(
                                            _controllerPassword.text);
                                    _validateVerifyPassword =
                                        (_controllerPassword.text ==
                                            _controllerVerifyPassword.text);
                                  });
                                  if (_validateName &&
                                      _validateEmail &&
                                      _validatePassword &&
                                      _validateVerifyPassword) {
                                    final progress = ProgressHUD.of(context);
                                    progress?.show();
                                    try {
                                      final result = await _auth
                                          .createUserWithEmailAndPassword(
                                              email: _controllerEmail.text,
                                              password:
                                                  _controllerPassword.text);
                                      User? user = result.user;
                                      await user?.updateDisplayName(
                                          _controllerName.text);
                                      Navigator.popUntil(
                                          context, (route) => route.isFirst);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainScreen(),
                                        ),
                                      );
                                      progress?.dismiss();
                                    } catch (e) {
                                      progress?.dismiss();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                  'Register',
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
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
