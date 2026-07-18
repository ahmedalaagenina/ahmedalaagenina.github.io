import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'data/cv_data.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_cubit.dart';

void main() {
  // Clean URLs (no #) — CI copies index.html to 404.html so GitHub Pages
  // serves the app for deep links like /links.
  usePathUrlStrategy();
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          title: '${CV.shortName} — ${CV.title}',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
