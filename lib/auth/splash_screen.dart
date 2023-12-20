import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'package:test_121/chat/messenger.dart';

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

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

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
              child: const Text('Chat app by Tie'))
        ],
      ),
    ); // Thay thế bằng widget của bạn
  }
}
