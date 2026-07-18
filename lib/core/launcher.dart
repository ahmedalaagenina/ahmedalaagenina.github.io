import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../data/cv_data.dart';
import '../theme/app_theme.dart';

abstract final class Launcher {
  static Future<void> open(String url) async {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  static Future<void> email() => open('mailto:${CV.email}');

  static Future<void> call(BuildContext context) =>
      _pickPhone(context, title: 'Call', onPick: (n) => open('tel:$n'));

  static Future<void> whatsapp(BuildContext context) => _pickPhone(
        context,
        title: 'WhatsApp',
        onPick: (n) => open('https://wa.me/${n.replaceAll('+', '')}'),
      );

  /// When several phone numbers exist, let the visitor choose one.
  static Future<void> _pickPhone(
    BuildContext context, {
    required String title,
    required void Function(String number) onPick,
  }) async {
    if (CV.phones.length == 1) {
      onPick(CV.phones.first.number);
      return;
    }
    final t = context.tokens;
    await showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: t.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: t.glassBorder),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(ctx).textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Choose a number',
                  style: Theme.of(ctx).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                for (final phone in CV.phones)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        onPick(phone.number);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: t.glassFill,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: t.glassBorder),
                        ),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.phone,
                              size: 14,
                              color: t.accentB,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    phone.label,
                                    style:
                                        Theme.of(ctx).textTheme.labelMedium,
                                  ),
                                  Text(
                                    phone.number,
                                    style: Theme.of(ctx).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
