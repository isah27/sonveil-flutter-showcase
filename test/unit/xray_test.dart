import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonveil/features/xray/domain/services/xray_math.dart';
import 'package:sonveil/features/xray/presentation/cubit/xray_cubit.dart';

void main() {
  test('drag up opens, clamped', () {
    expect(XrayMath.progressFromDrag(0, -130), closeTo(0.5, 1e-9));
    expect(XrayMath.progressFromDrag(0.9, -500), 1);
    expect(XrayMath.progressFromDrag(0.1, 500), 0);
  });

  test('release settles to nearest end', () {
    expect(XrayMath.settleTarget(0.49), 0);
    expect(XrayMath.settleTarget(0.5), 1);
  });

  test('layers spread when open and stay ordered', () {
    final double closed =
        XrayMath.layerY(4, 5, 0, 420) - XrayMath.layerY(0, 5, 0, 420);
    final double open =
        XrayMath.layerY(4, 5, 1, 420) - XrayMath.layerY(0, 5, 1, 420);
    expect(open, greaterThan(closed * 5));
    expect(XrayMath.layerY(2, 5, 1, 420), 210);
  });

  test('tap finds a layer only when open', () {
    final double y = XrayMath.layerY(3, 5, 1, 420);
    expect(XrayMath.layerAt(y, 5, 1, 420), 3);
    expect(XrayMath.layerAt(y, 5, 0.2, 420), isNull);
    expect(XrayMath.labelOpacity(0.4), 0);
    expect(XrayMath.labelOpacity(1), closeTo(1, 1e-9));
  });

  blocTest<XrayCubit, int?>(
    'select dedupes and clears',
    build: XrayCubit.new,
    act: (XrayCubit c) => c
      ..select(2)
      ..select(2)
      ..clear(),
    expect: () => <int?>[2, null],
  );
}
