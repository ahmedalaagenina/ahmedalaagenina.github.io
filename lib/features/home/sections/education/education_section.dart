import 'package:flutter/widgets.dart';

import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/section_heading.dart';

/// Education, certifications, languages and recognition: a quiet,
/// type-only section (no cards), two columns on wide screens.
class EducationSection extends StatelessWidget {
  const EducationSection({
    super.key,
    required this.copy,
    required this.education,
    required this.certifications,
    required this.languages,
    required this.recognition,
  });

  final EducationCopy copy;
  final List<Education> education;
  final List<Certification> certifications;
  final List<Language> languages;
  final List<Recognition> recognition;

  @override
  Widget build(BuildContext context) {
    final type = context.type;
    final t = context.tokens;

    Widget block(String? title, List<Widget> children) => Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Semantics(header: true, child: Text(title, style: type.title)),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );

    final degrees = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in education)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.title, style: type.bodyStrong),
                const SizedBox(height: 2),
                Text(e.institution, style: type.body),
                if (e.detail != null) Text(e.detail!, style: type.small),
                const SizedBox(height: 4),
                Text(e.period, style: type.mono),
                if (e.note != null) ...[
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${e.note!.label}: ',
                          style: TextStyle(
                            color: t.text,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: e.note!.text),
                      ],
                    ),
                    style: type.small,
                  ),
                ],
              ],
            ),
          ),
      ],
    );

    final certs = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final c in certifications)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name, style: type.bodyStrong),
                Text(c.issuer, style: type.small),
              ],
            ),
          ),
      ],
    );

    final langs = Wrap(
      spacing: 32,
      runSpacing: 8,
      children: [
        for (final l in languages)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${l.name}  ',
                  style: TextStyle(color: t.text, fontWeight: FontWeight.w500),
                ),
                TextSpan(text: l.level),
              ],
            ),
            style: type.body,
          ),
      ],
    );

    final awards = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final r in recognition)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.title, style: type.bodyStrong),
              Text(r.detail, style: type.small),
            ],
          ),
      ],
    );

    final left = Column(
      children: [
        // The section heading already says "Education".
        block(null, [degrees]),
        block(copy.languages, [langs, const SizedBox(height: 12)]),
      ],
    );
    final right = Column(
      children: [
        block(copy.certifications, [certs]),
        block(copy.recognition, [awards]),
      ],
    );

    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: copy.title),
          SizedBox(height: context.pick(32, desktop: 48)),
          if (context.isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 64),
                Expanded(child: right),
              ],
            )
          else ...[
            left,
            right,
          ],
        ],
      ),
    );
  }
}
