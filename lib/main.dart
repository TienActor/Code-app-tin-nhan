//import 'package:app_movie_tie/chat/messenger.dart';
import 'package:flutter/material.dart';
import 'package:test_121/auth/loginscreen.dart';

// fire base import
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 19,
          ),
          backgroundColor: Colors.blueAccent,
        ),
      ),
      home: const LoginScreen(), // call file method on messenger dart
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}