import 'package:go_router/go_router.dart';

import '../features/home/home_page.dart';
import '../features/links/links_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/links', builder: (context, state) => const LinksPage()),
  ],
  // Unknown paths (typos, old URLs) land on the home page instead of an
  // error screen.
  onException: (context, state, router) => router.go('/'),
);
