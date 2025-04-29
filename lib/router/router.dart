import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocr_demo/presentation/presentation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      name: Routes.home,
      builder: (context, state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: Routes.textRecognizer,
      name: Routes.textRecognizer,
      builder: (context, state) {
        return const TextRecognizerPage();
      },
    ),
  ],
);

abstract final class Routes {
  static const String home = "/";
  static const String textRecognizer = "/textRecognizer";
}
