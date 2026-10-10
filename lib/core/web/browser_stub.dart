/// VM / non-web fallbacks. See `browser.dart`.
library;

bool prefersReducedMotion() => false;

void onReducedMotionChange(void Function(bool reduce) callback) {}

/// Returns false when the platform can't trigger a file download, so the
/// caller can fall back to opening the URL.
bool downloadFile(String url, String fileName) => false;
