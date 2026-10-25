import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/eq_curve.dart';
import '../../domain/services/sound_shape.dart';

/// Five draggable points joined by a smooth curve.
class EqCanvas extends StatefulWidget {
  const EqCanvas({required this.curve, required this.onDrag, super.key});

  final EqCurve curve;
  final void Function(int band, double db) onDrag;

  @override
  State<EqCanvas> createState() => _EqCanvasState();
}

class _EqCanvasState extends State<EqCanvas> {
  int? _band;

  int _nearest(double x, double width) {
    final double step = width / EqCurve.bands.length;
    return (x / step).floor().clamp(0, EqCurve.bands.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final Size size = Size(c.maxWidth, AppSizes.eqHeight);
        void update(Offset p) {
          final int band = _band ?? _nearest(p.dx, size.width);
          widget.onDrag(band, SoundShape.dbFromY(p.dy, size.height));
        }

        return GestureDetector(
          key: const Key('eq-canvas'),
          onPanStart: (DragStartDetails d) {
            _band = _nearest(d.localPosition.dx, size.width);
            update(d.localPosition);
          },
          onPanUpdate: (DragUpdateDetails d) => update(d.localPosition),
          onPanEnd: (_) => _band = null,
          child: RepaintBoundary(
            child: CustomPaint(size: size, painter: EqPainter(widget.curve)),
          ),
        );
      },
    );
  }
}

class EqPainter extends CustomPainter {
  EqPainter(this.curve);

  final EqCurve curve;

  static Offset pointFor(int i, double db, Size s) {
    final double step = s.width / EqCurve.bands.length;
    return Offset(step * (i + 0.5), SoundShape.yFromDb(db, s.height));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint grid = Paint()
      ..color = AppColors.hairline
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      grid,
    );
    final List<Offset> pts = <Offset>[
      for (int i = 0; i < curve.gains.length; i++)
        pointFor(i, curve.gains[i], size),
    ];
    for (final Offset p in pts) {
      canvas.drawLine(Offset(p.dx, 0), Offset(p.dx, size.height), grid);
    }
    final Path path = Path()..moveTo(0, pts.first.dy);
    Offset prev = Offset(0, pts.first.dy);
    for (final Offset p in <Offset>[...pts, Offset(size.width, pts.last.dy)]) {
      final double cx = (prev.dx + p.dx) / 2;
      path.cubicTo(cx, prev.dy, cx, p.dy, p.dx, p.dy);
      prev = p;
    }
    final Path fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.haloMint.withValues(alpha: 0.28),
            AppColors.haloMint.withValues(alpha: 0),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.haloMint,
    );
    for (int i = 0; i < pts.length; i++) {
      canvas.drawCircle(
        pts[i],
        AppSizes.eqHandle / 2,
        Paint()..color = AppColors.obsidian,
      );
      canvas.drawCircle(
        pts[i],
        AppSizes.eqHandle / 2,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = AppColors.mist,
      );
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text:
              '${curve.gains[i] >= 0 ? '+' : ''}${curve.gains[i].toStringAsFixed(1)}',
          style: AppTypography.mono,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final double above = pts[i].dy - 20 - tp.height;
      tp.paint(
        canvas,
        Offset(pts[i].dx - tp.width / 2, above < 0 ? pts[i].dy + 18 : above),
      );
    }
  }

  @override
  bool shouldRepaint(EqPainter old) => old.curve != curve;
}
