import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

class FirebaseInitializer {
  Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    try {
      await Firebase.initializeApp(
        options: kIsWeb
            ? DefaultFirebaseOptions.currentPlatform
            : _platformOptions(),
      );
    } on UnsupportedError {
      if (kDebugMode) {
        debugPrint('Firebase is not configured for this platform yet.');
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        debugPrint('Firebase initialization skipped: ${error.message}');
      }
    }
  }

  FirebaseOptions? _platformOptions() {
    try {
      return DefaultFirebaseOptions.currentPlatform;
    } on UnsupportedError {
      return null;
    }
  }
}
