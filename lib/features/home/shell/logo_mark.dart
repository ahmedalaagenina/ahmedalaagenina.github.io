import 'package:flutter/widgets.dart';

import '../../../theme/app_theme.dart';

/// The `<AA />` monogram: brackets muted, letters in the text color.
/// Shared by the nav and the intro so the intro can fly one into the other.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, required this.logo, this.fontSize = 18});

  final String logo;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final style = TextStyle(
      fontFamily: Fonts.mono,
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: t.textMuted,
    );
    // Split "<AA />" into bracket / letters / bracket.
    final match = RegExp(r'^(<)(\w+)(.*)$').firstMatch(logo);
    if (match == null) return Text(logo, style: style);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: match.group(1)),
          TextSpan(
            text: match.group(2),
            style: TextStyle(color: t.text),
          ),
          TextSpan(text: match.group(3)),
        ],
      ),
      softWrap: false,
    );
  }
}
