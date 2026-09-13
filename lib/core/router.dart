import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notebook_editor/presentation/screens/content_screen.dart';
import 'package:notebook_editor/presentation/screens/home_shell.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@TypedShellRoute<HomeShellRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeRoute>(path: '/'),
    TypedGoRoute<ContentRoute>(path: '/contents/:id'),
  ],
)
class HomeShellRoute extends ShellRouteData {
  const HomeShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    final id = state.pathParameters['id'];
    return HomeShell(
      selectedContentId: id == null ? null : int.tryParse(id),
      navigator: navigator,
    );
  }
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(
        key: state.pageKey,
        child: const ContentScreen(contentId: null),
      );
}

class ContentRoute extends GoRouteData with $ContentRoute {
  const ContentRoute({required this.id});

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      NoTransitionPage(
        key: state.pageKey,
        child: ContentScreen(contentId: id),
      );

  // Web で push を使わないのは、push の遷移がアドレスバーに反映されないため
  // （GoRouter.optionURLReflectsImperativeAPIs が既定で false で、true にするのはドキュメントで非推奨）。
  // URL が変わらないとリロードで選択が外れるので、Web は go にしている。go でもブラウザの戻る/進むは効く。
  // それ以外は go だと履歴が積まれず戻るボタンでアプリが閉じるため push にしている。
  void open(BuildContext context) {
    if (kIsWeb) {
      go(context);
    } else {
      push<void>(context);
    }
  }
}

@riverpod
GoRouter router(Ref ref) => GoRouter(routes: $appRoutes);
