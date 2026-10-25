import 'package:equatable/equatable.dart';

/// Five-band EQ, gains in dB from -[maxDb] to +[maxDb].
class EqCurve extends Equatable {
  const EqCurve(this.gains);

  static const List<String> bands = <String>['60', '250', '1k', '4k', '12k'];
  static const double maxDb = 6;
  static const EqCurve flat = EqCurve(<double>[0, 0, 0, 0, 0]);

  final List<double> gains;

  /// Clamped and snapped to 0.5 dB, so a drag never emits noise.
  EqCurve withGain(int band, double db) {
    final double snapped = (db.clamp(-maxDb, maxDb) * 2).roundToDouble() / 2;
    if (gains[band] == snapped) return this;
    return EqCurve(<double>[
      for (int i = 0; i < gains.length; i++) i == band ? snapped : gains[i],
    ]);
  }

  @override
  List<Object?> get props => <Object?>[...gains];
}
