import 'dart:io';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_121/api/apis.dart';
import 'package:test_121/chat/messenger.dart';
import '../helper/dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isanimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isanimate = true;
      });
    });
  }

//handle google login btn click
  _handleGoogleBtnClick() {
    // for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        //log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e' as dynamic);
      // ignore: use_build_context_synchronously
      Dialogs.showSnackBar(context, 'Không thể kết nối wifi (Thử lại sau !!!)');
      return null;
    }
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
        title: const Text('Trang đăng nhập',
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
          AnimatedPositioned(
              top: mq.height * .15,
              right: _isanimate ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              duration: const Duration(seconds: 1),
              child: Image.asset('images/google.png')),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .05,
              width: mq.width * .9,
              height: mq.height * .07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },
                  icon: Image.asset('images/google.png'),
                  label: const Text('Đăng nhập với Google')))
        ],
      ),
    ); // Thay thế bằng widget của bạn
  }
}
