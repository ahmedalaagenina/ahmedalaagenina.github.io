import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/launcher.dart';
import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glass_card.dart';
import '../../../widgets/reveal.dart';
import '../../../widgets/section_header.dart';

class OpenSourceSection extends StatelessWidget {
  const OpenSourceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;

    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Open Source',
            title: 'Published Packages',
          ),
          for (final pkg in CV.openSource)
            Reveal(
              child: GlassCard(
                onTap: () => Launcher.open(pkg.url),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: t.accentGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.cube,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(pkg.name, style: theme.titleLarge),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: t.accentB.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: t.accentB.withValues(alpha: .4),
                                  ),
                                ),
                                child: Text(
                                  pkg.tag,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: t.accentB,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(pkg.description, style: theme.bodyMedium),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View on pub.dev',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: t.accentB,
                                ),
                              ),
                              const SizedBox(width: 6),
                              FaIcon(
                                FontAwesomeIcons.arrowUpRightFromSquare,
                                size: 11,
                                color: t.accentB,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
