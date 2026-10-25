import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonveil/features/listener/domain/entities/listener_profile.dart';
import 'package:sonveil/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:sonveil/features/onboarding/presentation/cubit/onboarding_state.dart';

void main() {
  OnboardingCubit make() => OnboardingCubit(typingDelay: Duration.zero);

  test('four answers build the profile', () async {
    final OnboardingCubit c = make();
    await c.start();
    await c.answerName('  isah ');
    await c.answerPlace(ListenPlace.studio);
    await c.answerListenFor(ListenFor.music);
    await c.answerTaste(SoundTaste.warm);
    expect(c.state.step, OnboardingStep.done);
    expect(c.state.progress, 1);
    expect(c.state.profile.name, 'Isah');
    expect(c.state.profile.place, ListenPlace.studio);
    expect(c.state.profile.taste, SoundTaste.warm);
    expect(
      c.state.messages.where((ChatMessage m) => m.text.contains('Isah')),
      isNotEmpty,
    );
    await c.close();
  });

  test('blank name falls back to Listener', () async {
    final OnboardingCubit c = make();
    await c.answerName('   ');
    expect(c.state.profile.name, 'Listener');
    await c.close();
  });

  blocTest<OnboardingCubit, OnboardingState>(
    'out-of-order answers are ignored',
    build: make,
    act: (OnboardingCubit c) => c.answerTaste(SoundTaste.bright),
    expect: () => <OnboardingState>[],
  );
}
