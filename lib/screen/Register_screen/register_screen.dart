import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:to_do_list/screen/Register_screen/register_box.dart';
import 'package:to_do_list/utils/constants.dart';

import '../../widget/button_to_welcome_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void dispose() {
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
                            padding: EdgeInsets.all(25.0),
                            child: RegisterBox(),
                          ),
                        ),
                      ),
                      const ButtonToWelcomeScreen(),
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
