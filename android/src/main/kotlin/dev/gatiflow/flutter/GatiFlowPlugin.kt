package dev.gatiflow.flutter

import android.app.Application
import dev.gatiflow.sdk.GatiFlow
import dev.gatiflow.sdk.analytics.Analytics
import dev.gatiflow.sdk.core.Config
import dev.gatiflow.sdk.crashes.Crashes
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class GatiFlowPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private var application: Application? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "dev.gatiflow/sdk")
        channel.setMethodCallHandler(this)
        application = binding.applicationContext as? Application
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {

            // ── Initialization ─────────────────────────────────────────────
            "start" -> {
                val appToken   = call.argument<String>("appToken") ?: return result.error("MISSING_TOKEN", "appToken is required", null)
                val services   = call.argument<List<String>>("services") ?: listOf("crashes", "analytics")
                val baseUrl    = call.argument<String>("baseUrl") ?: "https://app.gatiflow.dev"
                val debug      = call.argument<Boolean>("debugLogging") ?: false
                val crashSize  = call.argument<Int>("maxCrashQueueSize") ?: 50
                val batchSize  = call.argument<Int>("maxEventBatchSize") ?: 100
                val flushMs    = call.argument<Int>("flushIntervalMs")?.toLong() ?: 30_000L
                val anrMs      = call.argument<Int>("anrTimeoutMs")?.toLong() ?: 5_000L

                val config = Config.Builder(appToken)
                    .baseUrl(baseUrl)
                    .debugLogging(debug)
                    .maxCrashQueueSize(crashSize)
                    .maxEventBatchSize(batchSize)
                    .flushIntervalMs(flushMs)
                    .anrTimeoutMs(anrMs)
                    .build()

                val serviceClasses = buildList {
                    if ("crashes"   in services) add(Crashes::class.java)
                    if ("analytics" in services) add(Analytics::class.java)
                }

                application?.let { GatiFlow.start(it, config, serviceClasses) }
                result.success(null)
            }

            // ── Analytics ──────────────────────────────────────────────────
            "trackEvent" -> {
                val name  = call.argument<String>("name") ?: return result.error("MISSING_NAME", "event name is required", null)
                val props = call.argument<Map<String, Any>>("properties") ?: emptyMap()
                GatiFlow.analytics?.trackEvent(name, props)
                result.success(null)
            }
            "flush" -> {
                GatiFlow.analytics?.flush()
                result.success(null)
            }
            "setAnalyticsEnabled" -> {
                GatiFlow.analytics?.setEnabled(call.argument<Boolean>("enabled") ?: true)
                result.success(null)
            }

            // ── Crashes ────────────────────────────────────────────────────
            "trackError" -> {
                val message  = call.argument<String>("message") ?: ""
                val metadata = call.argument<Map<String, String>>("metadata") ?: emptyMap()
                GatiFlow.crashes?.trackError(RuntimeException(message), metadata)
                result.success(null)
            }
            "setCrashesEnabled" -> {
                GatiFlow.crashes?.setEnabled(call.argument<Boolean>("enabled") ?: true)
                result.success(null)
            }

            // ── Identity & lifecycle ───────────────────────────────────────
            "setUserId" -> {
                GatiFlow.setUserId(call.argument<String?>("userId"))
                result.success(null)
            }
            "stop" -> {
                GatiFlow.stop()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }
}
