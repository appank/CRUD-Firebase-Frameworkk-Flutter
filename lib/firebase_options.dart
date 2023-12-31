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
    apiKey: 'AIzaSyBpq6oT88vVIomKlXIOH7UEukpxpNuC33M',
    appId: '1:630620439690:web:8fbdd477b287d702f09973',
    messagingSenderId: '630620439690',
    projectId: 'crud-demo-b3ac0',
    authDomain: 'crud-demo-b3ac0.firebaseapp.com',
    storageBucket: 'crud-demo-b3ac0.appspot.com',
    measurementId: 'G-6EQREVYQ6C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCP0uahlfVky2bEF-BgeWnjtu0MWy4jM30',
    appId: '1:630620439690:android:fb0d214e24da3d95f09973',
    messagingSenderId: '630620439690',
    projectId: 'crud-demo-b3ac0',
    storageBucket: 'crud-demo-b3ac0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBql9aKzXzfsLZmHpKfDrlZ3bVCyiBWyjc',
    appId: '1:630620439690:ios:16bd9792944d360df09973',
    messagingSenderId: '630620439690',
    projectId: 'crud-demo-b3ac0',
    storageBucket: 'crud-demo-b3ac0.appspot.com',
    iosBundleId: 'com.example.crudFirebase',
  );
}
