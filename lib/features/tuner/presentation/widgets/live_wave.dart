import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../domain/entities/eq_curve.dart';
import '../../domain/services/sound_shape.dart';

/// A looping waveform shaped by an EQ curve. The controller drives the
/// painter's repaint directly, so no widget rebuilds per frame.
class LiveWave extends StatefulWidget {
  const LiveWave({
    required this.curve,
    this.height = 72,
    this.color,
    super.key,
  });

  final EqCurve curve;
  final double height;
  final Color? color;

  @override
  State<LiveWave> createState() => _LiveWaveState();
}

class _LiveWaveState extends State<LiveWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _phase = AnimationController(
    vsync: this,
    duration: AppDurations.waveLoop,
  )..repeat();

  @override
  void dispose() {
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: CustomPaint(
          painter: WavePainter(
            curve: widget.curve,
            phase: _phase,
            color: widget.color ?? AppColors.haloMint,
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  WavePainter({required this.curve, required this.phase, required this.color})
    : super(repaint: phase);

  final EqCurve curve;
  final Animation<double> phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double mid = size.height / 2;
    for (int layer = 0; layer < 3; layer++) {
      final Path path = Path();
      final double shift = layer * 0.12;
      for (int i = 0; i <= 120; i++) {
        final double x = i / 120;
        final double y =
            mid - SoundShape.waveAt(curve, x, phase.value + shift) * mid * 0.95;
        i == 0 ? path.moveTo(0, y) : path.lineTo(x * size.width, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = layer == 0 ? 2.4 : 1.2
          ..color = color.withValues(alpha: layer == 0 ? 1 : 0.35),
      );
    }
  }

  @override
  bool shouldRepaint(WavePainter old) =>
      old.curve != curve || old.color != color;
}
