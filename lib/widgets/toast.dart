import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Short confirmation message. Built on SnackBar so screen readers announce
/// it automatically.
void showToast(BuildContext context, String message, {IconData? icon}) {
  final t = context.tokens;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2400),
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: t.success),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
