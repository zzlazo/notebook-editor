import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notebook_editor/presentation/screens/home_screen.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(path: '/', routes: <TypedGoRoute<GoRouteData>>[
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => HomeScreen();
}

@riverpod
GoRouter router(Ref ref) => GoRouter(routes: $appRoutes);
