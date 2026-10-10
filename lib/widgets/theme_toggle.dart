import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/copy.dart';
import '../theme/app_theme.dart';
import '../theme/theme_cubit.dart';
import 'buttons.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key, required this.copy});

  final PaletteCopy copy;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    return IconAction(
      label: dark ? copy.switchToLight : copy.switchToDark,
      onTap: () => context.read<ThemeCubit>().toggle(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween(begin: 0.6, end: 1.0).animate(animation),
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Icon(
          dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          key: ValueKey(dark),
        ),
      ),
    );
  }
}
