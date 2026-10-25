import 'package:flutter/animation.dart';

import '../cubit/xray_cubit.dart';

/// Hands-free X-Ray for the screen recording (DEMO_TOUR builds only).
class XrayTour {
  XrayTour(this.explode, this.cubit, this.openSculpt);

  final AnimationController explode;
  final XrayCubit cubit;
  final Future<void> Function() openSculpt;

  Future<void> _wait(int ms) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  Future<void> run() async {
    await _wait(1200);
    await explode.animateTo(
      1,
      duration: const Duration(milliseconds: 1600),
      curve: Curves.easeInOutCubic,
    );
    await _wait(700);
    for (final int layer in <int>[3, 2, 1]) {
      if (cubit.isClosed) return;
      cubit.select(layer);
      await _wait(1300);
    }
    if (cubit.isClosed) return;
    cubit.clear();
    await explode.animateTo(
      0.35,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
    await explode.animateTo(
      1,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
    await _wait(800);
    if (!cubit.isClosed) await openSculpt();
  }
}
