/// GatiFlow Flutter SDK — crash reporting and analytics.
///
/// Initialize in `main()`:
/// ```dart
/// import 'package:gatiflow_flutter/gatiflow_flutter.dart';
///
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await GatiFlow.start(
///     GatiFlowConfig.builder('mhub_YOUR_TOKEN').build(),
///   );
///   runApp(const MyApp());
/// }
/// ```
library gatiflow_flutter;

export 'src/gatiflow.dart';
