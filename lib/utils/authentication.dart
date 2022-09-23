import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/firebase_options.dart';
import 'package:to_do_list/models/todo_operation.dart';
import 'package:to_do_list/screen/main_screen.dart';
import 'dart:io';

import '../screen/welcome_screen.dart';
import 'authentication_exception.dart';
import 'constants.dart';
import 'local_notification_services.dart';

class Authentication {
  static final _auth = FirebaseAuth.instance;
  static var _status = AuthStatus.unknown;

  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await Provider.of<TodoOperation>(context, listen: false)
            .setTodolist(context: context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MainScreen();
            },
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(
        content: e.toString(),
      ));
    }

    return firebaseApp;
  }

  static Future<AuthStatus> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _auth.currentUser!.updateDisplayName(name);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  static Future<AuthStatus> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  static Future<AuthStatus> signInAnonymousely() async {
    try {
      await _auth.signInAnonymously();
      _status = AuthStatus.successful;
    } on FirebaseAuthException catch (e) {
      _status = AuthExceptionHandler.handleAuthException(e);
    }
    return _status;
  }

  static Future<AuthStatus> resetPassword({required String email}) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
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
        await Provider.of<TodoOperation>(context, listen: false)
            .setTodolist(context: context);
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

  static Future<bool> confirmationDialog({
    required BuildContext context,
    required String confirmationText,
  }) async {
    bool confimation = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text(
          confirmationText,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              confimation = false;
              Navigator.pop(context);
            },
            child: const Text('Cancel', style: kDefaultTextColor),
          ),
          TextButton(
            onPressed: () {
              confimation = true;
              Navigator.pop(context);
            },
            child: const Text('OK', style: kDefaultTextColor),
          ),
        ],
      ),
    );
    return confimation;
  }

  // await Authentication.signOut(context: context);

  static Future<void> signOut({required BuildContext context}) async {
    var user = _auth.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        await deleteAccount(context: context);
      } else {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: Platform.isIOS
              ? DefaultFirebaseOptions.ios.iosClientId
              : DefaultFirebaseOptions.currentPlatform.androidClientId,
        );
        try {
          await googleSignIn.signOut();
          await _auth.signOut();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error signin out. Try again.',
            ),
          );
        }
      }
      Provider.of<TodoOperation>(context, listen: false).clearTodoList();
      LocalNotificationService.deleteNotification();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }

  static Future<void> deleteAccount({required BuildContext context}) async {
    var user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .collection('to_dos')
          .get()
          .then(
        (value) async {
          for (var element in value.docs) {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(user.uid)
                .collection('to_dos')
                .doc(element.id)
                .delete();
          }
        },
      );
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .delete();
      await user.delete();
      Provider.of<TodoOperation>(context, listen: false).clearTodoList();
      LocalNotificationService.deleteNotification();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
