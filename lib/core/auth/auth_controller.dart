import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebase/firebase_provider.dart';

@lazySingleton
class AuthController extends ChangeNotifier {
  AuthController(this._firebaseProvider, this._sharedPreferences);

  static const _rememberMeKey = 'remember_admin_session';

  final FirebaseProvider _firebaseProvider;
  final SharedPreferences _sharedPreferences;

  StreamSubscription<User?>? _authSubscription;

  bool _isInitialized = false;
  bool _isAuthenticated = false;
  bool _rememberMe = false;

  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _isAuthenticated;
  bool get rememberMe => _rememberMe;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _rememberMe = _sharedPreferences.getBool(_rememberMeKey) ?? false;

    // Check if we have a mock session on Linux
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.linux &&
        _rememberMe) {
      _isAuthenticated = true;
    }

    final auth = _firebaseProvider.auth;
    if (auth != null) {
      try {
        _authSubscription = auth.authStateChanges().listen(_handleAuthChange);

        if (!_rememberMe && auth.currentUser != null) {
          await auth.signOut();
        } else {
          _handleAuthChange(auth.currentUser);
        }
      } catch (error) {
        if (kDebugMode) {
          debugPrint(
            'Auth initialization skipped (Firebase probably not available): $error',
          );
        }
        _handleAuthChange(null);
      }
    } else {
      if (kDebugMode) {
        debugPrint(
          'Auth Controller: Firebase Auth is null (Not supported on this platform).',
        );
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final auth = _firebaseProvider.auth;
    if (auth == null) {
      // Mock sign-in for Linux/Unsupported platforms
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
        _isAuthenticated = true;
        _rememberMe = rememberMe;
        await _sharedPreferences.setBool(_rememberMeKey, rememberMe);
        notifyListeners();
        return;
      }
      throw Exception('Sign in is not supported on this platform.');
    }

    await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _rememberMe = rememberMe;
    await _sharedPreferences.setBool(_rememberMeKey, rememberMe);
    notifyListeners();
  }

  Future<void> signOut() async {
    _rememberMe = false;
    await _sharedPreferences.setBool(_rememberMeKey, false);

    final auth = _firebaseProvider.auth;
    if (auth != null) {
      await auth.signOut();
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
  }

  void _handleAuthChange(User? user) {
    _isAuthenticated = user != null;
    if (_isInitialized) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
