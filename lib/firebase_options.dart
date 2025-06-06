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
        return windows;
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
    apiKey: 'AIzaSyCv8zVAMULVY16F4VqScNZ1xKfkKZ2gzyo',
    appId: '1:667227505341:android:82bed0eebdbf8ad8462dd4',
    messagingSenderId: '667227505341',
    projectId: 'fir-6b182',
    storageBucket: 'fir-6b182.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBn67mB44d7yltClQ7ZK5ERszqRQnfWALU',
    appId: '1:667227505341:web:792c073ce2b769ea462dd4',
    messagingSenderId: '667227505341',
    projectId: 'fir-6b182',
    authDomain: 'fir-6b182.firebaseapp.com',
    storageBucket: 'fir-6b182.appspot.com',
    measurementId: 'G-1KCVNXPKB5',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBn67mB44d7yltClQ7ZK5ERszqRQnfWALU',
    appId: '1:667227505341:web:513cd8f539343877462dd4',
    messagingSenderId: '667227505341',
    projectId: 'fir-6b182',
    authDomain: 'fir-6b182.firebaseapp.com',
    storageBucket: 'fir-6b182.appspot.com',
    measurementId: 'G-6H5ZTQE98W',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC8LWECzqQ8Bmu7tVj6D0zQc93gyeAp2RQ',
    appId: '1:667227505341:ios:2b64efc7656af685462dd4',
    messagingSenderId: '667227505341',
    projectId: 'fir-6b182',
    storageBucket: 'fir-6b182.appspot.com',
    iosBundleId: 'com.example.foodyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC8LWECzqQ8Bmu7tVj6D0zQc93gyeAp2RQ',
    appId: '1:667227505341:ios:2b64efc7656af685462dd4',
    messagingSenderId: '667227505341',
    projectId: 'fir-6b182',
    storageBucket: 'fir-6b182.appspot.com',
    iosBundleId: 'com.example.foodyApp',
  );

}