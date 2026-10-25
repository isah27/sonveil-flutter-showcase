import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/utils/sized_asset_image.dart';
import '../../../catalog/domain/entities/device.dart';
import '../../domain/services/xray_math.dart';
import '../cubit/xray_cubit.dart';
import 'xray_painter.dart';

/// Drag up to look inside. The controller *is* the explode progress:
/// a drag writes its value, a release animates it to open or closed.
class XrayStage extends StatelessWidget {
  const XrayStage({required this.device, required this.explode, super.key});

  final Device device;
  final AnimationController explode;

  @override
  Widget build(BuildContext context) {
    const double h = AppSizes.xrayStage;
    final XrayCubit cubit = context.read<XrayCubit>();
    // Built once and passed as child: the photo never rebuilds per frame.
    final Widget photo = SizedAssetImage(
      device.asset,
      size: AppSizes.heroImage,
    );
    return GestureDetector(
      key: const Key('xray-stage'),
      onVerticalDragUpdate: (DragUpdateDetails d) =>
          explode.value = XrayMath.progressFromDrag(explode.value, d.delta.dy),
      onVerticalDragEnd: (_) => explode.animateTo(
        XrayMath.settleTarget(explode.value),
        duration: AppDurations.medium,
        curve: Curves.easeOutCubic,
      ),
      onTapUp: (TapUpDetails d) => cubit.select(
        XrayMath.layerAt(
          d.localPosition.dy,
          device.layers.length,
          explode.value,
          h,
        ),
      ),
      child: SizedBox(
        height: h,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: explode,
              child: photo,
              builder: (BuildContext context, Widget? child) {
                final double p = Curves.easeIn.transform(explode.value);
                return Opacity(
                  opacity: (1 - p * 0.92).clamp(0.0, 1.0),
                  child: Transform.scale(scale: 1 - 0.18 * p, child: child),
                );
              },
            ),
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(painter: ScanPainter(explode)),
              ),
            ),
            Positioned.fill(
              child: RepaintBoundary(
                child: BlocBuilder<XrayCubit, int?>(
                  builder: (BuildContext context, int? selected) => CustomPaint(
                    painter: XrayPainter(
                      layers: device.layers,
                      progress: explode,
                      selected: selected,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
