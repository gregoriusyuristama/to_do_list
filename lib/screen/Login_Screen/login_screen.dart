import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:to_do_list/screen/Login_Screen/login_box.dart';
import 'package:to_do_list/utils/constants.dart';
import '../local_widget/button_to_welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
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
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 25.0,
                              right: 25.0,
                              top: 25.0,
                            ),
                            child: LoginBox(),
                          ),
                        ),
                      ),
                      const ButtonToWelcomeScreen(),
                    ],
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