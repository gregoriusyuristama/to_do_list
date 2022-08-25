import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'dart:io';

class Authentication {
  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>
            Consumer<TodoOperation>(builder: (context, todoData, child) {
          todoData.setTodolist();
          return MainScreen();
        }),
      ));
    }
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS
          ? DefaultFirebaseOptions.ios.iosClientId
          : DefaultFirebaseOptions.currentPlatform.androidClientId,
    );

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context)
              .showSnackBar(Authentication.customSnackBar(
            content: 'Account already exist with a different credential',
          ));
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context)
              .showSnackBar(Authentication.customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(Authentication.customSnackBar(
          content: 'Error occurent using Google Sign In. Try again.',
        ));
      }
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: Platform.isIOS
          ? DefaultFirebaseOptions.ios.iosClientId
          : DefaultFirebaseOptions.currentPlatform.androidClientId,
    );
    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signin out. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
