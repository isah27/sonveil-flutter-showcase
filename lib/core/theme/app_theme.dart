import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.obsidian,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.haloMint,
      secondary: AppColors.ember,
      surface: AppColors.carbon,
    ),
    textTheme: const TextTheme(bodyMedium: AppTypography.body),
    splashFactory: InkSparkle.splashFactory,
  );
}
