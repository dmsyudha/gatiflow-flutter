## 1.0.0

* Initial release.
* Analytics: `trackEvent`, `flush`, `setEnabled`.
* Crashes: `trackError`, `setEnabled`, automatic unhandled exception capture.
* `GatiFlowConfig` builder with `baseUrl`, `debugLogging`, `services`, queue and flush controls.
* `GatiFlow.setUserId` for identity association across crashes and events.
* iOS (Swift) and Android (Kotlin) native implementations via platform channels.
