import 'package:flutter/material.dart';

import '../../features/catalog/domain/entities/device.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/tuner/presentation/pages/sculpt_page.dart';
import '../../features/tuner/presentation/pages/tuning_page.dart';
import '../../features/xray/presentation/pages/xray_page.dart';
import 'app_routes.dart';

/// The only place in core/ that knows about features.
abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings s) {
    final Widget page = switch (s.name) {
      AppRoutes.tuning => const TuningPage(),
      AppRoutes.home => const HomePage(),
      AppRoutes.xray => XrayPage(device: s.arguments! as Device),
      AppRoutes.sculpt => SculptPage(device: s.arguments! as Device),
      _ => const OnboardingPage(),
    };
    return PageRouteBuilder<void>(
      settings: s,
      transitionDuration: const Duration(milliseconds: 420),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, Animation<double> a, _, Widget child) =>
          FadeTransition(
            opacity: CurvedAnimation(parent: a, curve: Curves.easeOut),
            child: child,
          ),
    );
  }
}
