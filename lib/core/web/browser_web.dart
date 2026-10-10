/// Web implementation of `browser.dart`, using `dart:js_interop` directly
/// (no extra package needed for three small calls).
library;

import 'dart:js_interop';

@JS('matchMedia')
external _MediaQueryList _matchMedia(String query);

extension type _MediaQueryList._(JSObject _) implements JSObject {
  external bool get matches;
  external void addEventListener(String type, JSFunction listener);
}

extension type _MediaQueryListEvent._(JSObject _) implements JSObject {
  external bool get matches;
}

@JS('document')
external _Document get _document;

extension type _Document._(JSObject _) implements JSObject {
  external _Element createElement(String tag);
  external _Element get body;
}

extension type _Element._(JSObject _) implements JSObject {
  external set href(String value);
  external set download(String value);
  external void click();
  external void remove();
  external void append(_Element child);
}

const _reducedMotionQuery = '(prefers-reduced-motion: reduce)';

bool prefersReducedMotion() => _matchMedia(_reducedMotionQuery).matches;

void onReducedMotionChange(void Function(bool reduce) callback) {
  _matchMedia(_reducedMotionQuery).addEventListener(
    'change',
    ((_MediaQueryListEvent event) => callback(event.matches)).toJS,
  );
}

/// Triggers a real download (with a friendly file name) through an
/// `<a download>` element, instead of opening the PDF in a viewer tab.
bool downloadFile(String url, String fileName) {
  final anchor = _document.createElement('a')
    ..href = url
    ..download = fileName;
  _document.body.append(anchor);
  anchor.click();
  anchor.remove();
  return true;
}
