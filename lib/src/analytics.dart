import 'package:flutter/services.dart';

/// Provides event tracking. Access via [GatiFlow.analytics].
class AnalyticsService {
  final MethodChannel _channel;
  const AnalyticsService(this._channel);

  /// Track a named event with optional properties.
  ///
  /// ```dart
  /// GatiFlow.analytics.trackEvent('screen_view', properties: {'screen': 'Home'});
  /// ```
  Future<void> trackEvent(
    String name, {
    Map<String, dynamic> properties = const {},
  }) =>
      _channel.invokeMethod('trackEvent', {
        'name': name,
        'properties': properties,
      });

  /// Force-flush the event queue immediately (e.g. before logout).
  Future<void> flush() => _channel.invokeMethod('flush');

  /// Enable or disable analytics at runtime (e.g. based on user consent).
  Future<void> setEnabled(bool enabled) =>
      _channel.invokeMethod('setAnalyticsEnabled', {'enabled': enabled});
}
