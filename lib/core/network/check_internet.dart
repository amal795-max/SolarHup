import 'dart:io';

import 'package:untitled1/core/constants/environment_config.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();

  static const Duration _cacheDuration = Duration(seconds: 5);
  static const Duration _lookupTimeout = Duration(seconds: 3);

  bool? _cached;
  DateTime? _cachedAt;
  Future<bool>? _ongoingCheck;

  @override
  Future<bool> get isConnected async {
    final now = DateTime.now();
    if (_cached != null &&
        _cachedAt != null &&
        now.difference(_cachedAt!) < _cacheDuration) {
      return _cached!;
    }

    _ongoingCheck ??= _resolveConnectivity().then((result) {
      _cached = result;
      _cachedAt = DateTime.now();
      _ongoingCheck = null;
      return result;
    });

    return _ongoingCheck!;
  }

  Future<bool> _resolveConnectivity() async {
    final host = Uri.parse(EnvironmentConfig.apiEndpoint).host;
    if (host.isEmpty) return false;

    try {
      final result =
          await InternetAddress.lookup(host).timeout(_lookupTimeout);
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
