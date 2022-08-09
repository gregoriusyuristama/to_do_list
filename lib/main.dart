import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/screen/main_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

var appTheme = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: Color.fromRGBO(138, 218, 237, 1.0),
  androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
  textTheme: TextTheme(
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 32,
    ),
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 48,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    headline3: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    subtitle1: TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    subtitle2: TextStyle(
      color: Colors.black,
      fontSize: 15,
    ),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoi',
      theme: appTheme,
      home: MainScreen(),
    );
  }
}
