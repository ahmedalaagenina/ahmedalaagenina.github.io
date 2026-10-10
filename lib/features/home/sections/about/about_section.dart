import 'package:flutter/widgets.dart';

import '../../../../core/responsive.dart';
import '../../../../data/copy.dart';
import '../../../../theme/app_theme.dart';

/// The CV summary, set large: it is the paragraph a recruiter reads first.
class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.copy, required this.summary});

  final SectionCopy copy;
  final String summary;

  @override
  Widget build(BuildContext context) {
    final type = context.type;
    final t = context.tokens;
    final title = Semantics(
      header: true,
      child: Text(copy.title, style: type.display),
    );
    final body = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Text(
        summary,
        style: type.lead.copyWith(
          fontSize: context.pick(20, tablet: 22, desktop: 26),
          height: 1.45,
          color: t.text,
        ),
      ),
    );

    return MaxWidth(
      child: context.isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 300, child: title),
                Expanded(child: body),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [title, const SizedBox(height: 20), body],
            ),
    );
  }
}
