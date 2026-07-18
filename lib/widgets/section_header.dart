import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../theme/app_theme.dart';
import 'reveal.dart';

class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 2,
                decoration: BoxDecoration(gradient: t.accentGradient),
              ),
              const SizedBox(width: 10),
              Text(
                eyebrow.toUpperCase(),
                style: theme.labelMedium?.copyWith(
                  color: t.accentB,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: context.pick(
              desktop: theme.displaySmall,
              mobile: theme.headlineMedium,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(subtitle!, style: theme.bodyLarge),
            ),
          ],
          SizedBox(height: context.pick(desktop: 48.0, mobile: 32.0)),
        ],
      ),
    );
  }
}
