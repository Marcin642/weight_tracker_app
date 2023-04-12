import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weight_tracker_app/src/features/layout/presentation/logbook_screen.dart';
import 'package:weight_tracker_app/src/features/layout/presentation/shell_scaffold/shell_scaffold.dart';

enum AppRoute {
  home,
  logbook,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: AppRoute.home.name,
            builder: (context, state) => const Text('Home screen'),
          ),
          GoRoute(
            path: '/logbook',
            name: AppRoute.logbook.name,
            builder: (context, state) => const LogbookScreen(),
          ),
        ],
      ),
    ],
  );
});
