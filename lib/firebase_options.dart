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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA7n5AduJMZhb7owqnWSvYt7W5Geb3H_fs',
    appId: '1:374211178035:web:647df521eb296adee93d46',
    messagingSenderId: '374211178035',
    projectId: 'pergamonauth',
    authDomain: 'pergamonauth.firebaseapp.com',
    storageBucket: 'pergamonauth.appspot.com',
    measurementId: 'G-4NF4MS0ZXL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCphCTbYSIpSN86gMLyS_GkQsH0QfApOHc',
    appId: '1:374211178035:android:9b68d5a72adb938de93d46',
    messagingSenderId: '374211178035',
    projectId: 'pergamonauth',
    storageBucket: 'pergamonauth.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQftX6VWH9DMCCw5ObW_OUZtMFpnnUoek',
    appId: '1:374211178035:ios:93b2be3b2882cbc7e93d46',
    messagingSenderId: '374211178035',
    projectId: 'pergamonauth',
    storageBucket: 'pergamonauth.appspot.com',
    iosBundleId: 'com.instaflutter.freeloginscreen',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCQftX6VWH9DMCCw5ObW_OUZtMFpnnUoek',
    appId: '1:374211178035:ios:e7f4dd2042d17c85e93d46',
    messagingSenderId: '374211178035',
    projectId: 'pergamonauth',
    storageBucket: 'pergamonauth.appspot.com',
    iosBundleId: 'com.instaflutter.freeloginscreen.mac',
  );
}
