import 'dart:math' as math;

import '../../../listener/domain/entities/listener_profile.dart';
import '../entities/eq_curve.dart';

/// Pure maths behind the tuning visuals. Unit tested.
abstract final class SoundShape {
  static EqCurve presetFor(SoundTaste taste) => switch (taste) {
    SoundTaste.warm => const EqCurve(<double>[4.5, 2.5, 0, -1.5, -2]),
    SoundTaste.balanced => EqCurve.flat,
    SoundTaste.bright => const EqCurve(<double>[-1.5, -1, 0.5, 3, 4.5]),
  };

  /// Blends two curves, t in 0–1. Used by the tuning reveal.
  static EqCurve lerp(EqCurve a, EqCurve b, double t) => EqCurve(<double>[
    for (int i = 0; i < a.gains.length; i++)
      a.gains[i] + (b.gains[i] - a.gains[i]) * t,
  ]);

  /// Height of the live waveform at x (0–1) and phase (0–1), in -1..1.
  /// Each band adds a sine; low bands are slow and wide, high bands fast.
  static double waveAt(EqCurve curve, double x, double phase) {
    const List<double> freq = <double>[1, 2, 4, 7, 11];
    double y = 0;
    for (int i = 0; i < freq.length; i++) {
      final double weight = 0.5 + curve.gains[i] / EqCurve.maxDb * 0.45;
      y += weight * math.sin(2 * math.pi * (freq[i] * x + phase * (i + 1)));
    }
    return y / freq.length;
  }

  /// Converts a vertical position in an EQ box to dB.
  static double dbFromY(double y, double height) {
    final double t = (y / height).clamp(0.0, 1.0);
    return EqCurve.maxDb - t * 2 * EqCurve.maxDb;
  }

  static double yFromDb(double db, double height) =>
      (EqCurve.maxDb - db) / (2 * EqCurve.maxDb) * height;
}
