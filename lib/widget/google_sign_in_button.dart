import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/screen/main_screen/main_screen.dart';
import 'package:to_do_list/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kDefaultColor),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              backgroundColor: kDefaultColor,
            ),
            onPressed: () async {
              setState(() {
                _isSigningIn = true;
              });
              // sign in method
              try {
                User? user =
                    await Authentication.signInWithGoogle(context: context);
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MainScreen(),
                  ));
                }
                setState(() {
                  _isSigningIn = false;
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
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: const [
                  Image(
                    image: AssetImage("assets/images/google_logo.png"),
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: FittedBox(
                      child: Text(
                        'Login with Google',
                        style: TextStyle(
                            // fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
