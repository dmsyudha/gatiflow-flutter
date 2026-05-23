/// SDK configuration. Build via [GatiFlowConfig.builder].
class GatiFlowConfig {
  final String appToken;
  final List<GatiFlowService> services;
  final String baseUrl;
  final bool debugLogging;
  final int maxCrashQueueSize;
  final int maxEventBatchSize;
  final int flushIntervalMs;
  final int anrTimeoutMs;

  const GatiFlowConfig._({
    required this.appToken,
    required this.services,
    required this.baseUrl,
    required this.debugLogging,
    required this.maxCrashQueueSize,
    required this.maxEventBatchSize,
    required this.flushIntervalMs,
    required this.anrTimeoutMs,
  });

  static GatiFlowConfigBuilder builder(String appToken) =>
      GatiFlowConfigBuilder._(appToken);

  Map<String, dynamic> toMap() => {
        'appToken': appToken,
        'services': services.map((s) => s.name).toList(),
        'baseUrl': baseUrl,
        'debugLogging': debugLogging,
        'maxCrashQueueSize': maxCrashQueueSize,
        'maxEventBatchSize': maxEventBatchSize,
        'flushIntervalMs': flushIntervalMs,
        'anrTimeoutMs': anrTimeoutMs,
      };
}

/// Which SDK services to activate.
enum GatiFlowService { crashes, analytics }

/// Fluent builder for [GatiFlowConfig].
class GatiFlowConfigBuilder {
  final String _appToken;
  List<GatiFlowService> _services = GatiFlowService.values;
  String _baseUrl = 'https://app.gatiflow.dev';
  bool _debugLogging = false;
  int _maxCrashQueueSize = 50;
  int _maxEventBatchSize = 100;
  int _flushIntervalMs = 30000;
  int _anrTimeoutMs = 5000;

  GatiFlowConfigBuilder._(this._appToken);

  GatiFlowConfigBuilder services(List<GatiFlowService> value) {
    _services = value;
    return this;
  }

  GatiFlowConfigBuilder baseUrl(String value) {
    _baseUrl = value;
    return this;
  }

  GatiFlowConfigBuilder debugLogging(bool value) {
    _debugLogging = value;
    return this;
  }

  GatiFlowConfigBuilder maxCrashQueueSize(int value) {
    _maxCrashQueueSize = value;
    return this;
  }

  GatiFlowConfigBuilder maxEventBatchSize(int value) {
    _maxEventBatchSize = value;
    return this;
  }

  GatiFlowConfigBuilder flushIntervalMs(int value) {
    _flushIntervalMs = value;
    return this;
  }

  GatiFlowConfigBuilder anrTimeoutMs(int value) {
    _anrTimeoutMs = value;
    return this;
  }

  GatiFlowConfig build() => GatiFlowConfig._(
        appToken: _appToken,
        services: _services,
        baseUrl: _baseUrl,
        debugLogging: _debugLogging,
        maxCrashQueueSize: _maxCrashQueueSize,
        maxEventBatchSize: _maxEventBatchSize,
        flushIntervalMs: _flushIntervalMs,
        anrTimeoutMs: _anrTimeoutMs,
      );
}
