import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/utils/constants.dart';
import 'package:to_do_list/controller/todo_operation.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/screen/welcome_screen.dart';
import 'utils/firebase_options.dart';
import 'utils/local_notification_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService.initialize();
  runApp(const MyApp());
}

var appTheme = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: kDefaultColor,
  useMaterial3: true,
  textTheme: const TextTheme(
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
      fontSize: 24,
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
    return ChangeNotifierProvider(
      create: (context) => TodoOperation(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDoi',
        theme: appTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}
