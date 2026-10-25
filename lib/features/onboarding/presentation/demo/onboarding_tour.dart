import 'package:flutter/widgets.dart';

import '../../../listener/domain/entities/listener_profile.dart';
import '../cubit/onboarding_cubit.dart';

/// Hands-free answers for the screen recording (DEMO_TOUR builds only).
class OnboardingTour {
  OnboardingTour(this.cubit, this.name, this.finish);

  final OnboardingCubit cubit;
  final TextEditingController name;
  final VoidCallback finish;

  Future<void> _wait(int ms) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  Future<void> run() async {
    await _wait(1800);
    for (final String ch in 'Isah'.split('')) {
      name.text += ch;
      await _wait(160);
    }
    await _wait(400);
    await cubit.answerName(name.text);
    await _wait(900);
    await cubit.answerPlace(ListenPlace.studio);
    await _wait(900);
    await cubit.answerListenFor(ListenFor.music);
    await _wait(1100);
    await cubit.answerTaste(SoundTaste.warm);
    await _wait(1400);
    if (!cubit.isClosed) finish();
  }
}
