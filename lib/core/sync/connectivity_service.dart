import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  Stream<bool> watchConnection() {
    return _connectivity.onConnectivityChanged.map(_hasConnection).distinct();
  }

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnection(result);
  }

  bool _hasConnection(List<ConnectivityResult> result) {
    return result.any((item) => item != ConnectivityResult.none);
  }
}
