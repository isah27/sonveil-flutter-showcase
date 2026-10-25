import '../../../listener/domain/entities/listener_profile.dart';
import '../cubit/sculpt_cubit.dart';

/// Hands-free sculpting for the screen recording (DEMO_TOUR builds only).
class SculptTour {
  SculptTour(this.cubit);

  final SculptCubit cubit;

  Future<void> _wait(int ms) =>
      Future<void>.delayed(Duration(milliseconds: ms));

  Future<void> _glide(int band, double to) async {
    final double from = cubit.state.curve.gains[band];
    for (int i = 1; i <= 14; i++) {
      if (cubit.isClosed) return;
      cubit.drag(band, from + (to - from) * i / 14);
      await _wait(40);
    }
  }

  Future<void> run() async {
    await _wait(1500);
    await _glide(0, 6);
    await _glide(3, 3);
    await _glide(4, 5);
    await _wait(900);
    if (cubit.isClosed) return;
    cubit.applyPreset(SoundTaste.bright);
    await _wait(1300);
    if (cubit.isClosed) return;
    cubit.applyPreset(SoundTaste.warm);
    await _wait(1100);
    await _glide(1, 4.5);
    await _wait(700);
    if (!cubit.isClosed) cubit.save();
  }
}
