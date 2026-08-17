import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class _RetryState {
  final int count;
  final DateTime updatedAt;

  const _RetryState({required this.count, required this.updatedAt});
}

/// Tracks retry attempts per route so repeated failures can fall back to home.
class ErrorRetryGuard {
  ErrorRetryGuard._();

  static const _maxRetriesBeforeHome = 2;
  static const _stateTtl = Duration(minutes: 5);

  static final Map<String, _RetryState> _attempts = {};

  static String routeKey(BuildContext context) {
    try {
      return GoRouterState.of(context).matchedLocation;
    } catch (_) {
      return context.hashCode.toString();
    }
  }

  static int retryCount(String key) {
    _purgeExpired(key);
    return _attempts[key]?.count ?? 0;
  }

  static void recordRetry(String key) {
    _purgeExpired(key);
    final current = _attempts[key]?.count ?? 0;
    _attempts[key] = _RetryState(
      count: current + 1,
      updatedAt: DateTime.now(),
    );
  }

  static bool shouldRedirectHome(String key) =>
      retryCount(key) >= _maxRetriesBeforeHome;

  static void clear(String key) => _attempts.remove(key);

  static void clearFor(BuildContext context) => clear(routeKey(context));

  static void _purgeExpired(String key) {
    final state = _attempts[key];
    if (state == null) return;
    if (DateTime.now().difference(state.updatedAt) > _stateTtl) {
      _attempts.remove(key);
    }
  }
}
