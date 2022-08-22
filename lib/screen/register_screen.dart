import 'package:flutter/material.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:to_do_list/screen/main_screen.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
], clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  void initState() {
    super.initState();
  }

  Future<void> signup(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result = await _auth.signInWithCredential(authCredential);
      User? user = result.user;
      print(user.toString());
      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        ).then((value) => _googleSignIn.disconnect());
      }
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

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
                FittedBox(
                  child: Text(
                    'To Do List : ToDoi',
                    style: Theme.of(context).textTheme.headline1?.copyWith(
                          fontSize: 40,
                        ),
                    textAlign: TextAlign.left,
                  ),
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
                          onChanged: (value) => email = value,
                          keyboardType: TextInputType.emailAddress,
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
                          onChanged: (value) => password = value,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainScreen(),
                                ),
                              );
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('Register'),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(75, 191, 221, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    'Login Using Google',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    signup(context);
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
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
