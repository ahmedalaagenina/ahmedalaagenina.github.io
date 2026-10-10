import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';

/// CV bullets with a short accent dash as the marker.
class BulletList extends StatelessWidget {
  const BulletList({
    super.key,
    required this.bullets,
    this.spacing = 12,
    this.maxWidth = 720,
  });

  final List<String> bullets;
  final double spacing;

  /// Caps the line length near 80 characters for comfortable reading.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final bullet in bullets)
            Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 2,
                    margin: const EdgeInsets.only(top: 12, right: 14),
                    color: t.signal,
                  ),
                  Expanded(child: Text(bullet, style: type.body)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
