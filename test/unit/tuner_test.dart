import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonveil/features/listener/domain/entities/listener_profile.dart';
import 'package:sonveil/features/tuner/domain/entities/eq_curve.dart';
import 'package:sonveil/features/tuner/domain/services/sound_shape.dart';
import 'package:sonveil/features/tuner/presentation/cubit/sculpt_cubit.dart';

void main() {
  test('gain is clamped and snapped to 0.5 dB', () {
    expect(EqCurve.flat.withGain(0, 9).gains[0], EqCurve.maxDb);
    expect(EqCurve.flat.withGain(1, 2.26).gains[1], 2.5);
    expect(identical(EqCurve.flat.withGain(2, 0.1), EqCurve.flat), isTrue);
  });

  test('lerp runs flat to preset', () {
    final EqCurve warm = SoundShape.presetFor(SoundTaste.warm);
    expect(SoundShape.lerp(EqCurve.flat, warm, 0), EqCurve.flat);
    expect(SoundShape.lerp(EqCurve.flat, warm, 1), warm);
  });

  test('y and dB round-trip', () {
    for (final double db in <double>[-6, -2.5, 0, 3, 6]) {
      expect(
        SoundShape.dbFromY(SoundShape.yFromDb(db, 220), 220),
        closeTo(db, 1e-9),
      );
    }
  });

  test('presets differ', () {
    expect(
      SoundShape.presetFor(SoundTaste.warm),
      isNot(SoundShape.presetFor(SoundTaste.bright)),
    );
  });

  blocTest<SculptCubit, SculptState>(
    'dragging leaves the preset, saving marks saved',
    build: () => SculptCubit(SoundTaste.balanced),
    act: (SculptCubit c) => c
      ..drag(4, 4)
      ..drag(4, 4.1)
      ..save(),
    expect: () => <Matcher>[
      isA<SculptState>().having((SculptState s) => s.preset, 'preset', isNull),
      isA<SculptState>().having((SculptState s) => s.saved, 'saved', isTrue),
    ],
  );
}
