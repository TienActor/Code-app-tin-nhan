import 'dart:developer';

import 'package:flutter/material.dart';
// fire base import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:test_121/auth/splash_screen.dart';
//dot env
import 'package:flutter_dotenv/flutter_dotenv.dart';

late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load .env file
  await dotenv.load(fileName: ".env");
  _initializeFirebase(); // Đợi cho việc khởi tạo Firebase hoàn thành.  await
  //enter to full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]) //set up xoay màn hình
      .then((value) {
    runApp(const MyApp());
  });
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
      home: const SplashScreen(), // call file method on messenger dart
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        appId: dotenv.env['FIREBASE_APP_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['FIREBASE_PROJECT_ID']!),
  ); //DefaultFirebaseOptions.currentPlatform

  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'showing message description',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    
  );
  log('\nNotification register channel $result');
}

class NotificationVisibility {
}
