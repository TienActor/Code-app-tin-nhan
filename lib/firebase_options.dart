// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwDymtmHdEJ5SoMqsnQ53UnVM6kXIwAfI',
    appId: '1:735612036112:android:8939586587dfea30cdd695',
    messagingSenderId: '735612036112',
    projectId: 'test-121-f65b0',
    storageBucket: 'test-121-f65b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCOaV1FX3-AixqCggNcv1HybMcj1Pe6q0',
    appId: '1:735612036112:ios:5866af915e261399cdd695',
    messagingSenderId: '735612036112',
    projectId: 'test-121-f65b0',
    storageBucket: 'test-121-f65b0.appspot.com',
    androidClientId: '735612036112-eubpl0pmvtr9hv08f8jhg2ps5f6kv158.apps.googleusercontent.com',
    iosClientId: '735612036112-boov9a7723637p3bmpmi93cqjqe6isla.apps.googleusercontent.com',
    iosBundleId: 'com.example.test121',
  );
}
