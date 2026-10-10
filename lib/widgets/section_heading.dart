import 'package:flutter/widgets.dart';

import '../theme/app_theme.dart';

/// Section title plus an optional intro paragraph, left aligned. The title
/// is marked as a header so screen-reader users can jump between sections.
class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, this.intro});

  final String title;
  final String? intro;

  @override
  Widget build(BuildContext context) {
    final type = context.type;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(title, style: type.display)),
        if (intro != null) ...[
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(intro!, style: type.lead),
          ),
        ],
      ],
    );
  }
}
