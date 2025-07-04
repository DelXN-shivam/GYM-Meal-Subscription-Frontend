// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCxaT0QNp7Q68DXN9ayoYepQc-hGZNJu_s',
    appId: '1:250513066006:web:b5b1fb6f8a6a6f6a5c8d37',
    messagingSenderId: '250513066006',
    projectId: 'gym-meal-subscription',
    authDomain: 'gym-meal-subscription.firebaseapp.com',
    storageBucket: 'gym-meal-subscription.firebasestorage.app',
    measurementId: 'G-PQ9PYCVL9C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBeHl8uVqUvLM-JBoRfhHstyhzJRIcPkhw',
    appId: '1:250513066006:android:45a24ce198bbf2475c8d37',
    messagingSenderId: '250513066006',
    projectId: 'gym-meal-subscription',
    storageBucket: 'gym-meal-subscription.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDviPCdPK08NdVK6zHmVlF7AgsH33Gj8lM',
    appId: '1:250513066006:ios:0355ed6f2496a1b45c8d37',
    messagingSenderId: '250513066006',
    projectId: 'gym-meal-subscription',
    storageBucket: 'gym-meal-subscription.firebasestorage.app',
    iosBundleId: 'com.example.gymAppUser1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDviPCdPK08NdVK6zHmVlF7AgsH33Gj8lM',
    appId: '1:250513066006:ios:0355ed6f2496a1b45c8d37',
    messagingSenderId: '250513066006',
    projectId: 'gym-meal-subscription',
    storageBucket: 'gym-meal-subscription.firebasestorage.app',
    iosBundleId: 'com.example.gymAppUser1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCxaT0QNp7Q68DXN9ayoYepQc-hGZNJu_s',
    appId: '1:250513066006:web:e871c2f04277928e5c8d37',
    messagingSenderId: '250513066006',
    projectId: 'gym-meal-subscription',
    authDomain: 'gym-meal-subscription.firebaseapp.com',
    storageBucket: 'gym-meal-subscription.firebasestorage.app',
    measurementId: 'G-NRP2TDRZW4',
  );
}
