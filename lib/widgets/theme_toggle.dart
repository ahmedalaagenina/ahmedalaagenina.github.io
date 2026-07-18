import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/app_theme.dart';
import '../theme/theme_cubit.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Tooltip(
      message: isDark ? 'Light mode' : 'Dark mode',
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => context.read<ThemeCubit>().toggle(),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: t.glassFill,
            border: Border.all(color: t.glassBorder),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) =>
                RotationTransition(turns: anim, child: child),
            child: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              key: ValueKey(isDark),
              size: 18,
              color: t.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
