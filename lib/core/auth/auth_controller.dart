import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AuthController extends ChangeNotifier {
  AuthController(this._firebaseAuth, this._sharedPreferences);

  static const _rememberMeKey = 'remember_admin_session';

  final FirebaseAuth _firebaseAuth;
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
    _authSubscription = _firebaseAuth.authStateChanges().listen(
      _handleAuthChange,
    );

    if (!_rememberMe && _firebaseAuth.currentUser != null) {
      await _firebaseAuth.signOut();
    } else {
      _handleAuthChange(_firebaseAuth.currentUser);
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
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
    await _firebaseAuth.signOut();
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
