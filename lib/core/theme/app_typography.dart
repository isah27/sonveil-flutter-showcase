import 'package:flutter/painting.dart';

import 'app_colors.dart';

/// Sora for display, Inter for body, Space Mono for specs and readouts.
abstract final class AppTypography {
  static const String _display = 'Sora';
  static const String _body = 'Inter';
  static const String _mono = 'SpaceMono';

  static const TextStyle display = TextStyle(
    fontFamily: _display,
    fontSize: 30,
    height: 1.15,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
    color: AppColors.mist,
    letterSpacing: -0.4,
  );
  static const TextStyle title = TextStyle(
    fontFamily: _display,
    fontSize: 20,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
    color: AppColors.mist,
  );
  static const TextStyle wordmark = TextStyle(
    fontFamily: _display,
    fontSize: 18,
    fontVariations: <FontVariation>[FontVariation('wght', 700)],
    letterSpacing: 6,
    color: AppColors.mist,
  );
  static const TextStyle body = TextStyle(
    fontFamily: _body,
    fontSize: 15,
    height: 1.4,
    color: AppColors.mist,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: _body,
    fontSize: 12.5,
    color: AppColors.muted,
  );
  static const TextStyle label = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mist,
  );
  static const TextStyle mono = TextStyle(
    fontFamily: _mono,
    fontSize: 12,
    letterSpacing: 1.2,
    color: AppColors.haloMint,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );
}
