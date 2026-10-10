import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import 'pressable.dart';

/// Lets the visitor choose which number to call or message. Skips the
/// dialog entirely when there is only one number.
Future<void> pickPhone(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<Phone> phones,
  required void Function(Phone phone) onPick,
}) async {
  if (phones.length == 1) {
    onPick(phones.single);
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final t = dialogContext.tokens;
      final type = dialogContext.type;
      return Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: type.headline),
                const SizedBox(height: 4),
                Text(subtitle, style: type.small),
                const SizedBox(height: 16),
                for (final phone in phones)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Pressable(
                      semanticLabel: '${phone.label} ${phone.display}',
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        onPick(phone);
                      },
                      builder: (context, states) => AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: states.contains(WidgetState.hovered)
                              ? t.surfaceRaised
                              : t.background,
                          borderRadius: BorderRadius.circular(Radii.m),
                          border: Border.all(color: t.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(phone.label, style: type.small),
                            Text(phone.display, style: type.label),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
