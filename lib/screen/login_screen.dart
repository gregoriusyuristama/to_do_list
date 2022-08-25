import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/screen/register_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
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
                            controller: controllerEmail,
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
                            controller: controllerPassword,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Consumer<TodoOperation>(
                            builder: (context, todoData, child) =>
                                ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  await _auth.signInWithEmailAndPassword(
                                    email: controllerEmail.text,
                                    password: controllerPassword.text,
                                  );
                                  FirebaseAuth.instance
                                      .idTokenChanges()
                                      .listen((User? user) {
                                    if (user != null) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Consumer<TodoOperation>(builder:
                                                    (context, todoData, child) {
                                              todoData.setTodolist();
                                              return MainScreen();
                                            }),
                                          ));
                                    }
                                  });

                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  print(e.toString());
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //       e.toString(),
                                  //     ),
                                  //   ),
                                  // );
                                }
                              },
                              child: Text('Login'),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(75, 191, 221, 1.0),
                              ),
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
