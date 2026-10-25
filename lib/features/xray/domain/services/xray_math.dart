/// Pure layout maths for the X-Ray exploded view. Unit tested.
abstract final class XrayMath {
  /// Pixels of vertical drag for a full explode.
  static const double travel = 260;

  /// Dragging up (negative dy) opens the device.
  static double progressFromDrag(double progress, double dy) =>
      (progress - dy / travel).clamp(0.0, 1.0);

  /// Where the release should settle: open past halfway, closed otherwise.
  static double settleTarget(double progress) => progress >= 0.5 ? 1 : 0;

  /// Vertical centre of layer [index] of [count], for a stage [height].
  /// Closed, the layers sit 6 px apart; open, they spread over 78 %.
  static double layerY(int index, int count, double progress, double height) {
    final double gap = 6 + progress * (height * 0.78 / count - 6);
    return height / 2 + (index - (count - 1) / 2) * gap;
  }

  /// The layer under a tap, or null if the device is closed or you missed.
  static int? layerAt(double y, int count, double progress, double height) {
    if (progress < 0.6) return null;
    int best = 0;
    double bestD = double.infinity;
    for (int i = 0; i < count; i++) {
      final double d = (layerY(i, count, progress, height) - y).abs();
      if (d < bestD) {
        bestD = d;
        best = i;
      }
    }
    return bestD <= height * 0.78 / count / 2 ? best : null;
  }

  /// Labels fade in over the last part of the explode.
  static double labelOpacity(double progress) =>
      ((progress - 0.55) / 0.45).clamp(0.0, 1.0);
}
