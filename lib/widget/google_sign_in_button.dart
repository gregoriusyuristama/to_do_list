import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoOperation>(
      builder: (context, todoData, child) => _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kDefaultColor),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(40),
                primary: kDefaultColor,
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                // sign in method
                User? user =
                    await Authentication.signInWithGoogle(context: context);
                await todoData.setTodolist();

                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ));
                }
                setState(() {
                  _isSigningIn = false;
                });
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: FittedBox(
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage("assets/images/google_logo.png"),
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                              // fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
