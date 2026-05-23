# GatiFlow Flutter SDK

Crash reporting and analytics for Flutter apps.
Wraps the native iOS and Android GatiFlow SDKs via platform channels.

[![pub.dev](https://img.shields.io/pub/v/gatiflow_flutter)](https://pub.dev/packages/gatiflow_flutter)
![iOS 16+](https://img.shields.io/badge/iOS-16%2B-blue)
![Android minSdk 21](https://img.shields.io/badge/Android-minSdk%2021-brightgreen)

---

## Installation

```yaml
# pubspec.yaml
dependencies:
  gatiflow_flutter: ^1.0.0
```

```sh
flutter pub get
```

---

## Quick Start

Initialize **before** `runApp()` so crashes during startup are captured.

```dart
import 'package:flutter/material.dart';
import 'package:gatiflow_flutter/gatiflow_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GatiFlow.start(
    GatiFlowConfig.builder('mhub_YOUR_APP_TOKEN').build(),
  );

  runApp(const MyApp());
}
```

---

## Analytics

```dart
// Simple event
GatiFlow.analytics.trackEvent('screen_view');

// Event with properties
GatiFlow.analytics.trackEvent('purchase_completed', properties: {
  'product_id': 'pro_monthly',
  'price': 9.99,
  'currency': 'USD',
});

// Force-flush before logout
GatiFlow.analytics.flush();

// Opt out (e.g. based on user consent)
GatiFlow.analytics.setEnabled(false);
```

---

## Crash Reporting

```dart
try {
  await riskyOperation();
} catch (e, stack) {
  GatiFlow.crashes.trackError(e.toString(), metadata: {
    'screen': 'CheckoutScreen',
    'stack':  stack.toString().substring(0, 200),
  });
}
```

---

## User Identity

```dart
// After login
await GatiFlow.setUserId(user.id);

// After logout
await GatiFlow.setUserId(null);
```

---

## Advanced Configuration

```dart
await GatiFlow.start(
  GatiFlowConfig.builder('mhub_YOUR_TOKEN')
    .services([GatiFlowService.crashes, GatiFlowService.analytics])
    .baseUrl('https://your-server.com')     // default: https://app.gatiflow.dev
    .debugLogging(kDebugMode)               // verbose native logs
    .maxCrashQueueSize(100)                 // offline crash queue (default: 50)
    .maxEventBatchSize(200)                 // events per batch (default: 100)
    .flushIntervalMs(15000)                 // flush interval ms (default: 30000)
    .anrTimeoutMs(3000)                     // ANR/hang threshold (default: 5000)
    .build(),
);
```

---

## API Reference

| Method | Description |
|--------|-------------|
| `GatiFlow.start(config)` | Initialize with a `GatiFlowConfig` |
| `GatiFlow.setUserId(id)` | Attach identity (`null` to clear) |
| `GatiFlow.stop()` | Stop all services |
| `GatiFlow.analytics.trackEvent(name, {properties})` | Record a custom event |
| `GatiFlow.analytics.flush()` | Force-flush the event queue |
| `GatiFlow.analytics.setEnabled(bool)` | Enable / disable analytics |
| `GatiFlow.crashes.trackError(message, {metadata})` | Report a handled error |
| `GatiFlow.crashes.setEnabled(bool)` | Enable / disable crash reporting |
