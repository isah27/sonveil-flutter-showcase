import 'package:flutter_bloc/flutter_bloc.dart';

/// Which part of the device is in focus. The explode progress itself is
/// per-frame and lives in an AnimationController, never in the cubit.
class XrayCubit extends Cubit<int?> {
  XrayCubit() : super(null);

  void select(int? layer) {
    if (layer == state) return;
    emit(layer);
  }

  void clear() => select(null);
}
