import Flutter
import UIKit
import GatiFlow

public class GatiFlowPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "dev.gatiflow/sdk",
            binaryMessenger: registrar.messenger()
        )
        let instance = GatiFlowPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]

        switch call.method {

        // ── Initialization ─────────────────────────────────────────────────
        case "start":
            guard let appToken = args["appToken"] as? String else {
                return result(FlutterError(code: "MISSING_TOKEN", message: "appToken is required", details: nil))
            }
            let services   = args["services"]          as? [String] ?? ["crashes", "analytics"]
            let baseUrl    = args["baseUrl"]            as? String   ?? "https://app.gatiflow.dev"
            let debug      = args["debugLogging"]       as? Bool     ?? false
            let crashSize  = args["maxCrashQueueSize"]  as? Int      ?? 50
            let batchSize  = args["maxEventBatchSize"]  as? Int      ?? 100
            let flushMs    = args["flushIntervalMs"]    as? Double   ?? 30_000
            let watchdogMs = args["anrTimeoutMs"]       as? Double   ?? 5_000

            let config = Config.Builder(appToken: appToken)
                .baseUrl(baseUrl)
                .debugLogging(debug)
                .maxCrashQueueSize(crashSize)
                .maxEventBatchSize(batchSize)
                .flushIntervalMs(flushMs)
                .watchdogTimeoutMs(watchdogMs)
                .build()

            let serviceList: [GatiFlowService] = services.compactMap {
                switch $0 {
                case "crashes":   return Crashes()
                case "analytics": return Analytics()
                default:          return nil
                }
            }

            GatiFlow.shared.start(config: config, services: serviceList)
            result(nil)

        // ── Analytics ──────────────────────────────────────────────────────
        case "trackEvent":
            let name  = args["name"]       as? String         ?? ""
            let props = args["properties"] as? [String: Any]
            GatiFlow.shared.analytics?.trackEvent(name, properties: props)
            result(nil)

        case "flush":
            GatiFlow.shared.analytics?.flush()
            result(nil)

        case "setAnalyticsEnabled":
            GatiFlow.shared.analytics?.setEnabled(args["enabled"] as? Bool ?? true)
            result(nil)

        // ── Crashes ────────────────────────────────────────────────────────
        case "trackError":
            let message  = args["message"]  as? String            ?? ""
            let metadata = args["metadata"] as? [String: String]  ?? [:]
            struct BridgedError: Error, LocalizedError {
                let msg: String
                var errorDescription: String? { msg }
            }
            GatiFlow.shared.crashes?.trackError(BridgedError(msg: message), metadata: metadata)
            result(nil)

        case "setCrashesEnabled":
            GatiFlow.shared.crashes?.setEnabled(args["enabled"] as? Bool ?? true)
            result(nil)

        // ── Identity & lifecycle ───────────────────────────────────────────
        case "setUserId":
            GatiFlow.shared.setUserId(args["userId"] as? String)
            result(nil)

        case "stop":
            GatiFlow.shared.stop()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
