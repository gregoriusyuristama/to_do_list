import 'package:flutter/material.dart';
import 'package:to_do_list/screen/register_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight = (mediaQuery.size.height - mediaQuery.padding.top);
    final bottomPadding =
        EdgeInsets.only(bottom: mediaQuery.padding.bottom + 100);
    final availableWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.lightBlue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[400]!,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey[400]!,
                            ),
                            labelText: 'E-mail',
                            floatingLabelStyle: TextStyle(
                              color: Colors.lightBlue,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.normal,
                          ),
                          cursorColor: Colors.lightBlue,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.lightBlue,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey[400]!,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey[400]!,
                            ),
                            labelText: 'Password',
                            floatingLabelStyle: TextStyle(
                              color: Colors.lightBlue,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.normal,
                          ),
                          cursorColor: Colors.lightBlue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Login'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(75, 191, 221, 1.0),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  child: Text('Login Using Google'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
