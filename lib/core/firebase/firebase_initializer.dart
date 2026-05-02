import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseInitializer {
  Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) {
      return;
    }

    try {
      await Firebase.initializeApp();
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
}
