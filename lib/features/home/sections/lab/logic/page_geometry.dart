import 'dart:ui';

/// Maps between a PDF page (points, origin at the *bottom-left*, y up) and
/// its on-screen view (pixels, origin at the top-left, y down).
///
/// The signature field's position is stored in PDF points, never in screen
/// pixels: the same field must land on the same spot of the document
/// whatever size the page is displayed at. Mixing the two spaces (or
/// forgetting the flipped y axis) is the classic "the signature moved"
/// bug.
class PageGeometry {
  const PageGeometry({required this.page, required this.view});

  /// Page size in PDF points (US Letter is 612 × 792).
  final Size page;

  /// Size the page is drawn at, in logical pixels.
  final Size view;

  double get scale => view.width / page.width;

  /// View rect (top-left origin) of a field whose bottom-left corner is at
  /// [pdfOrigin] and whose size is [pdfSize], both in points.
  Rect toView(Offset pdfOrigin, Size pdfSize) {
    final left = pdfOrigin.dx * scale;
    final top = (page.height - pdfOrigin.dy - pdfSize.height) * scale;
    return Rect.fromLTWH(
      left,
      top,
      pdfSize.width * scale,
      pdfSize.height * scale,
    );
  }

  /// Moves a field by a screen-space [delta] and returns its new PDF origin,
  /// clamped so the field stays fully on the page.
  Offset moveBy(Offset pdfOrigin, Size pdfSize, Offset delta) {
    final x = pdfOrigin.dx + delta.dx / scale;
    // Screen y grows downward, PDF y grows upward: invert the delta.
    final y = pdfOrigin.dy - delta.dy / scale;
    return clamp(Offset(x, y), pdfSize);
  }

  Offset clamp(Offset pdfOrigin, Size pdfSize) => Offset(
    pdfOrigin.dx.clamp(0.0, page.width - pdfSize.width),
    pdfOrigin.dy.clamp(0.0, page.height - pdfSize.height),
  );
}
