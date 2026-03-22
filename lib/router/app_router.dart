import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/home_page.dart';
import '../pages/quick_links_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/links',
      builder: (BuildContext context, GoRouterState state) {
        return const QuickLinksPage();
      },
    ),
    GoRoute(
      path: '/qr',
      builder: (BuildContext context, GoRouterState state) {
        return const QuickLinksPage();
      },
    ),
  ],
);
