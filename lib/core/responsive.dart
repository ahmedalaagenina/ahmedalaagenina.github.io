import 'package:flutter/widgets.dart';

abstract final class Breakpoints {
  static const double mobile = 640;
  static const double tablet = 1024;
  static const double maxContent = 1180;
}

extension ResponsiveX on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Pick a value per form factor: `context.pick(desktop: 64, mobile: 32)`.
  T pick<T>({required T desktop, T? tablet, required T mobile}) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet ?? desktop;
    return mobile;
  }

  /// Horizontal page gutter.
  double get gutter => pick(desktop: 48, tablet: 32, mobile: 20);
}

/// Centers content at [Breakpoints.maxContent] with responsive gutters.
class MaxWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidth({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.maxContent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          child: child,
        ),
      ),
    );
  }
}
