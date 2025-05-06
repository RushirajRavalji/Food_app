import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyD5FeaL0B2SX6lPg9dCtjLrG4fm7Wdlpqs',
    appId: '1:209516034097:web:0b6583a85ce066f0a17d10',
    messagingSenderId: '209516034097',
    projectId: 'foodapp-3024c',
    authDomain: 'foodapp-3024c.firebaseapp.com',
    storageBucket: 'foodapp-3024c.firebasestorage.app',
    measurementId: 'G-20SP8RLX5X',
  );

  // Replace these values with your actual Firebase configuration

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4f94VwnKr41_kmFYpIezpsAsz1VXWnRI',
    appId: '1:209516034097:android:81a6174484f7a17aa17d10',
    messagingSenderId: '209516034097',
    projectId: 'foodapp-3024c',
    storageBucket: 'foodapp-3024c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJgIM2vucuxAoim6nYrpq4iF9XFOyrwEc',
    appId: '1:209516034097:ios:866333e0746104baa17d10',
    messagingSenderId: '209516034097',
    projectId: 'foodapp-3024c',
    storageBucket: 'foodapp-3024c.firebasestorage.app',
    iosBundleId: 'com.example.foodApp',
  );

}