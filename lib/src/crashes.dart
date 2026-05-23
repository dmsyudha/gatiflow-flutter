import 'package:flutter/services.dart';

/// Provides crash and error reporting. Access via [GatiFlow.crashes].
class CrashesService {
  final MethodChannel _channel;
  const CrashesService(this._channel);

  /// Report a handled error with an optional metadata map.
  ///
  /// ```dart
  /// try {
  ///   await riskyOp();
  /// } catch (e, stack) {
  ///   GatiFlow.crashes.trackError(e.toString(), metadata: {'screen': 'Checkout'});
  /// }
  /// ```
  Future<void> trackError(
    String message, {
    Map<String, String> metadata = const {},
  }) =>
      _channel.invokeMethod('trackError', {
        'message': message,
        'metadata': metadata,
      });

  /// Enable or disable crash reporting at runtime (e.g. based on user consent).
  Future<void> setEnabled(bool enabled) =>
      _channel.invokeMethod('setCrashesEnabled', {'enabled': enabled});
}
