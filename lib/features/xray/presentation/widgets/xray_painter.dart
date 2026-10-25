import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../catalog/domain/entities/device.dart';
import '../../domain/services/xray_math.dart';

/// Draws the device as stacked discs that pull apart, with leader-line
/// labels. Repaints from the explode animation, not from rebuilds.
class XrayPainter extends CustomPainter {
  XrayPainter({
    required this.layers,
    required this.progress,
    required this.selected,
  }) : super(repaint: progress);

  final List<DeviceLayer> layers;
  final Animation<double> progress;
  final int? selected;

  @override
  void paint(Canvas canvas, Size size) {
    final double p = progress.value;
    if (p <= 0.001) return;
    final int n = layers.length;
    final double cx = size.width * (0.5 - 0.16 * p);
    final double labelA = XrayMath.labelOpacity(p);

    // Bottom layers first, so each upper top face covers the one below.
    for (int i = n - 1; i >= 0; i--) {
      final DeviceLayer l = layers[i];
      final double y = XrayMath.layerY(i, n, p, size.height);
      final double rx = l.widthFactor * size.width * 0.36;
      final double ry = rx * 0.3;
      final bool hot = selected == i;
      final Rect top = Rect.fromCenter(
        center: Offset(cx, y),
        width: rx * 2,
        height: ry * 2,
      );
      final Rect bottom = top.shift(Offset(0, l.depth));
      final Path side = Path()
        ..moveTo(top.left, top.center.dy)
        ..arcTo(bottom, 3.14159, -3.14159, false)
        ..lineTo(top.right, top.center.dy)
        ..arcTo(top, 0, 3.14159, false)
        ..close();
      canvas.drawPath(
        side,
        Paint()..color = AppColors.carbonRaised.withValues(alpha: p),
      );
      canvas.drawOval(
        top,
        Paint()
          ..shader = RadialGradient(
            colors: <Color>[
              (hot ? AppColors.haloMint : AppColors.titanium).withValues(
                alpha: (hot ? 0.75 : 0.35) * p,
              ),
              AppColors.carbon.withValues(alpha: p),
            ],
          ).createShader(top),
      );
      canvas.drawOval(
        top,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = hot ? 2.4 : 1.2
          ..color = (hot ? AppColors.haloMint : AppColors.titanium).withValues(
            alpha: 0.9 * p,
          ),
      );

      if (labelA > 0) {
        final double lx = size.width * 0.70;
        final Paint lead = Paint()
          ..strokeWidth = 1
          ..color = (hot ? AppColors.haloMint : AppColors.muted).withValues(
            alpha: labelA,
          );
        canvas.drawLine(Offset(cx + rx, y), Offset(lx - 6, y), lead);
        canvas.drawCircle(Offset(cx + rx, y), 2.5, lead);
        final TextPainter tp = TextPainter(
          text: TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: '${l.name}\n',
                style: AppTypography.label.copyWith(
                  fontSize: 12.5,
                  color: (hot ? AppColors.haloMint : AppColors.mist).withValues(
                    alpha: labelA,
                  ),
                ),
              ),
              TextSpan(
                text: l.spec,
                style: AppTypography.mono.copyWith(
                  fontSize: 10,
                  color: AppColors.muted.withValues(alpha: labelA),
                ),
              ),
            ],
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: size.width - lx);
        tp.paint(canvas, Offset(lx, y - tp.height / 2));
      }
    }
  }

  @override
  bool shouldRepaint(XrayPainter old) =>
      old.selected != selected || old.layers != layers;
}

/// The scanning line that sweeps down the photo as it opens.
class ScanPainter extends CustomPainter {
  ScanPainter(this.progress) : super(repaint: progress);

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final double p = progress.value;
    if (p <= 0 || p >= 1) return;
    final double y = size.height * (0.1 + 0.8 * p);
    final Rect glow = Rect.fromLTWH(0, y - 40, size.width, 40);
    canvas.drawRect(
      glow,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.haloMint.withValues(alpha: 0),
            AppColors.haloMint.withValues(alpha: 0.35 * (1 - p)),
          ],
        ).createShader(glow),
    );
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      Paint()
        ..strokeWidth = 2
        ..color = AppColors.haloMint.withValues(alpha: 1 - p * 0.6),
    );
  }

  @override
  bool shouldRepaint(ScanPainter old) => false;
}
