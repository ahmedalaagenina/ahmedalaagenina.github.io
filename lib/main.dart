import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'data/portfolio_data.dart';
import 'features/easter_egg/debug_paint.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';
import 'widgets/cursor/cursor_follower.dart';
import 'widgets/reduced_motion_scope.dart';

void main() {
  // Clean URLs (/links). CI copies index.html to 404.html so GitHub Pages
  // serves the app for deep links, and index.html rewrites old /#/ links.
  usePathUrlStrategy();
  // The default 500ms debounce makes scroll reveals feel late. 120ms keeps
  // them responsive while still batching the visibility checks.
  VisibilityDetectorController.instance.updateInterval = const Duration(
    milliseconds: 120,
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    const identity = Portfolio.identity;
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          title: '${identity.displayName} | ${identity.fullTitle}',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: appRouter,
          builder: (context, child) => ReducedMotionScope(
            child: DebugPaintScope(
              copy: Portfolio.copy.easterEgg,
              child: CursorFollower(child: child!),
            ),
          ),
        ),
      ),
    );
  }
}
