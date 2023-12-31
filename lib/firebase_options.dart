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
    apiKey: 'AIzaSyDDXRdoaF8T2F4PSqnlgOxDrelDyhbL0Rk',
    appId: '1:297787439752:web:b7bdf1862eac2f4296bd3d',
    messagingSenderId: '297787439752',
    projectId: 'highschoolhub',
    authDomain: 'highschoolhub.firebaseapp.com',
    storageBucket: 'highschoolhub.appspot.com',
    measurementId: 'G-178FY6JP89',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2hl51bcM-PeNfOrfq3GUemzyUDPb3A_c',
    appId: '1:297787439752:android:b9254a2ee0c9a4ec96bd3d',
    messagingSenderId: '297787439752',
    projectId: 'highschoolhub',
    storageBucket: 'highschoolhub.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBbrmHWB6c_ytanBKxG-6drELyIeq0-980',
    appId: '1:297787439752:ios:a215391b8935a44596bd3d',
    messagingSenderId: '297787439752',
    projectId: 'highschoolhub',
    storageBucket: 'highschoolhub.appspot.com',
    androidClientId: '297787439752-ma83pfhh3h7vko9kfk7737c07nsiqqko.apps.googleusercontent.com',
    iosClientId: '297787439752-esu9hd570qdmbomshm34lq5odpmact7g.apps.googleusercontent.com',
    iosBundleId: 'com.example.highschoolhub',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBbrmHWB6c_ytanBKxG-6drELyIeq0-980',
    appId: '1:297787439752:ios:24620001da61aba896bd3d',
    messagingSenderId: '297787439752',
    projectId: 'highschoolhub',
    storageBucket: 'highschoolhub.appspot.com',
    androidClientId: '297787439752-ma83pfhh3h7vko9kfk7737c07nsiqqko.apps.googleusercontent.com',
    iosClientId: '297787439752-hdcp89d7rdj1lulgun3aca0bf1vpgttq.apps.googleusercontent.com',
    iosBundleId: 'com.example.highschoolhub.RunnerTests',
  );
}
