import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/launcher.dart';
import '../../../core/responsive.dart';
import '../../../data/cv_data.dart';
import '../../../theme/app_theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final theme = Theme.of(context).textTheme;
    final year = DateTime.now().year;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.glassBorder)),
      ),
      child: MaxWidth(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 16,
          children: [
            Text(
              '© $year ${CV.name}. Built with Flutter — '
              'yes, this site is a Flutter app.',
              style: theme.bodySmall,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FooterIcon(
                  icon: FontAwesomeIcons.github,
                  onTap: () => Launcher.open(CV.githubUrl),
                ),
                _FooterIcon(
                  icon: FontAwesomeIcons.linkedinIn,
                  onTap: () => Launcher.open(CV.linkedinUrl),
                ),
                _FooterIcon(
                  icon: FontAwesomeIcons.envelope,
                  onTap: Launcher.email,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterIcon extends StatelessWidget {
  final FaIconData icon;
  final VoidCallback onTap;

  const _FooterIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FaIcon(icon, size: 15, color: t.textMuted),
        ),
      ),
    );
  }
}
