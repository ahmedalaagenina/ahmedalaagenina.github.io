/// Browser-only capabilities behind a conditional import.
///
/// `dart:js_interop` only exists when compiling for the web, so importing it
/// directly would break `flutter test` (which runs on the Dart VM). The stub
/// is picked on the VM, the real implementation in the browser.
library;

export 'browser_stub.dart' if (dart.library.js_interop) 'browser_web.dart';
