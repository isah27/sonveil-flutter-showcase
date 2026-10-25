import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../listener/domain/entities/listener_profile.dart';
import '../../domain/entities/eq_curve.dart';
import '../../domain/services/sound_shape.dart';

class SculptState {
  const SculptState({
    required this.curve,
    required this.preset,
    this.saved = false,
  });

  final EqCurve curve;

  /// The preset the curve matches, or null once you've sculpted it.
  final SoundTaste? preset;
  final bool saved;

  @override
  bool operator ==(Object other) =>
      other is SculptState &&
      other.curve == curve &&
      other.preset == preset &&
      other.saved == saved;

  @override
  int get hashCode => Object.hash(curve, preset, saved);
}

/// Sound Sculpt: drag the five points, or start from a preset.
class SculptCubit extends Cubit<SculptState> {
  SculptCubit(SoundTaste taste)
    : super(SculptState(curve: SoundShape.presetFor(taste), preset: taste));

  void drag(int band, double db) {
    final EqCurve next = state.curve.withGain(band, db);
    if (next == state.curve) return;
    emit(SculptState(curve: next, preset: null));
  }

  void applyPreset(SoundTaste taste) =>
      emit(SculptState(curve: SoundShape.presetFor(taste), preset: taste));

  void save() =>
      emit(SculptState(curve: state.curve, preset: state.preset, saved: true));
}
