import 'package:flutter/material.dart';

import '../../../core/motion/springs.dart';
import '../../../core/responsive.dart';
import '../../../data/copy.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/pressable.dart';
import 'section_id.dart';

/// Full-screen menu for phones and tablets: large, thumb-friendly targets
/// instead of a search box that would pop the keyboard open.
Future<void> showMobileMenu(
  BuildContext context, {
  required NavCopy copy,
  required String downloadLabel,
  required ValueChanged<SectionId> onSelect,
  required VoidCallback onDownloadCv,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: copy.closeMenu,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (dialogContext, animation, secondary) => _MobileMenu(
      copy: copy,
      downloadLabel: downloadLabel,
      onSelect: (section) {
        Navigator.of(dialogContext).pop();
        onSelect(section);
      },
      onDownloadCv: onDownloadCv,
    ),
    transitionBuilder: (context, animation, secondary, child) {
      if (context.reduceMotion) return child;
      final curved = CurvedAnimation(
        parent: animation,
        curve: SpringCurve(Springs.gentle),
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, -0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({
    required this.copy,
    required this.downloadLabel,
    required this.onSelect,
    required this.onDownloadCv,
  });

  final NavCopy copy;
  final String downloadLabel;
  final ValueChanged<SectionId> onSelect;
  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    return Material(
      color: t.background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 68,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconAction(
                    icon: const Icon(Icons.close_rounded),
                    label: copy.closeMenu,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  children: [
                    for (final section in SectionId.values.skip(1))
                      Pressable(
                        semanticLabel: section.label(copy),
                        onTap: () => onSelect(section),
                        pressScale: 0.98,
                        builder: (context, states) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            section.label(copy),
                            style: type.display.copyWith(
                              fontSize: 34,
                              color: states.contains(WidgetState.pressed)
                                  ? t.signalText
                                  : t.text,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  label: downloadLabel,
                  icon: const Icon(Icons.download_rounded),
                  onTap: onDownloadCv,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
