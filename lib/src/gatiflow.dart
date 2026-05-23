import 'package:flutter/services.dart';
import 'analytics.dart';
import 'config.dart';
import 'crashes.dart';

export 'analytics.dart';
export 'config.dart';
export 'crashes.dart';

/// Main entry point for the GatiFlow Flutter SDK.
///
/// ## Minimal setup
/// ```dart
/// await GatiFlow.start(
///   GatiFlowConfig.builder('mhub_YOUR_TOKEN').build(),
/// );
/// ```
///
/// ## Advanced setup
/// ```dart
/// await GatiFlow.start(
///   GatiFlowConfig.builder('mhub_YOUR_TOKEN')
///     .debugLogging(kDebugMode)
///     .flushIntervalMs(15000)
///     .build(),
/// );
/// ```
class GatiFlow {
  GatiFlow._();

  static const _channel = MethodChannel('dev.gatiflow/sdk');

  /// Access the analytics service to track events.
  static final analytics = AnalyticsService(_channel);

  /// Access the crash reporting service to report handled errors.
  static final crashes = CrashesService(_channel);

  /// Initialize the SDK. Call this in [main()] before [runApp()].
  ///
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await GatiFlow.start(GatiFlowConfig.builder('mhub_TOKEN').build());
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> start(GatiFlowConfig config) =>
      _channel.invokeMethod('start', config.toMap());

  /// Associate a user identity with all subsequent crashes and events.
  /// Pass `null` to clear the identity on logout.
  static Future<void> setUserId(String? userId) =>
      _channel.invokeMethod('setUserId', {'userId': userId});

  /// Stop all services and release resources.
  static Future<void> stop() => _channel.invokeMethod('stop');
}
