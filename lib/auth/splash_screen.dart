import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_121/auth/login_screen.dart';
import 'package:test_121/chat/messenger.dart';
import '../main.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // bool _isanimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      //enter to full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (FirebaseAuth.instance.currentUser != null) {
        log('\nUser: ${FirebaseAuth.instance.currentUser}' as dynamic);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//initializing media query (for getting device screen size)
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 1,
        // title cho trang tin nhan
        title: const Text('Trang dang nhap',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 25,
            )),
        //them icon search va phim chuc nang cho icon
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              left: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/google.png')),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .07,
              child:
                  const Text('Tie ,App nhắn tin', textAlign: TextAlign.center))
        ],
      ),
    ); // Thay thế bằng widget của bạn
  }
}
