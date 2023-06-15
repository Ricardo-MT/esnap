// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_stg.dart';
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDAv4mPBbDyhUrgKnE6n3ufm3EuH6nR7ko',
    appId: '1:559114535701:web:d04a522349eadfda2c9f1c',
    messagingSenderId: '559114535701',
    projectId: 'esnap-541ef',
    authDomain: 'esnap-541ef.firebaseapp.com',
    storageBucket: 'esnap-541ef.appspot.com',
    measurementId: 'G-ZRW4H782J1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA685J27z7xvCfMtM3MMyw3ohz9456YMWU',
    appId: '1:559114535701:android:4b6d5a1b24e4bc2e2c9f1c',
    messagingSenderId: '559114535701',
    projectId: 'esnap-541ef',
    storageBucket: 'esnap-541ef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAP2fpSsJda1rftSQpBVucIY5eDzZGMNw',
    appId: '1:559114535701:ios:d44a375f8740a8082c9f1c',
    messagingSenderId: '559114535701',
    projectId: 'esnap-541ef',
    storageBucket: 'esnap-541ef.appspot.com',
    iosClientId:
        '559114535701-nlj6hh2m8c04radj04lojh73gr1ba365.apps.googleusercontent.com',
    iosBundleId: 'com.ricardo.esnap.app.esnap.stg',
  );
}
