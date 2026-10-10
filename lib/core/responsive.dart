import 'package:flutter/widgets.dart';

enum FormFactor { mobile, tablet, desktop }

abstract final class Breakpoints {
  static const double tablet = 640;
  static const double desktop = 1024;
  static const double maxContent = 1200;
}

extension ResponsiveX on BuildContext {
  /// Uses `sizeOf` so widgets only rebuild when the size changes, not on
  /// every MediaQuery change (keyboard insets, text scale, etc.).
  double get screenWidth => MediaQuery.sizeOf(this).width;

  FormFactor get formFactor {
    final w = screenWidth;
    if (w >= Breakpoints.desktop) return FormFactor.desktop;
    if (w >= Breakpoints.tablet) return FormFactor.tablet;
    return FormFactor.mobile;
  }

  bool get isMobile => formFactor == FormFactor.mobile;
  bool get isDesktop => formFactor == FormFactor.desktop;

  /// Mobile-first value picker: `context.pick(20, desktop: 48)`.
  T pick<T>(T mobile, {T? tablet, T? desktop}) => switch (formFactor) {
    FormFactor.mobile => mobile,
    FormFactor.tablet => tablet ?? mobile,
    FormFactor.desktop => desktop ?? tablet ?? mobile,
  };

  /// Horizontal page gutter.
  double get gutter => pick(20, tablet: 32, desktop: 48);

  /// Vertical space between sections.
  double get sectionGap => pick(96, tablet: 128, desktop: 168);
}

/// Centers content at [Breakpoints.maxContent] with responsive gutters.
class MaxWidth extends StatelessWidget {
  const MaxWidth({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContent,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // Align + an infinite-width SizedBox: the content always spans the
    // full (capped) width, so left-aligned sections line up with the nav
    // instead of being centered as a narrow block.
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth + context.gutter * 2),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}
