import 'package:flutter/material.dart';
// fire base import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:test_121/auth/splash_screen.dart';


late Size mq;

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  //enter to full screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]).then((value) {
    _initializeFirebase(); // Đợi cho việc khởi tạo Firebase hoàn thành.  await
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
    options: const FirebaseOptions(
        apiKey: "AIzaSyAE3s_SqHGfHB6TwHD5RRGPKrD03Q0VTuY",
        appId: "1:735612036112:android:8939586587dfea30cdd695",
        messagingSenderId: "735612036112",
        projectId: "test-121-f65b0"),
  ); //DefaultFirebaseOptions.currentPlatform      AIzaSyCwDymtmHdEJ5SoMqsnQ53UnVM6kXIwAfI
}
