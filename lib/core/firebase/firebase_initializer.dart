import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

class FirebaseInitializer {
  Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    // Official Firebase plugins currently don't support Linux.
    // Skipping initialization on Linux to avoid PlatformException.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
      if (kDebugMode) {
        debugPrint(
          'Firebase is not supported on Linux. Skipping initialization.',
        );
      }
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
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Firebase initialization failed with error: $error');
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
