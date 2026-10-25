import 'package:flutter/widgets.dart';

import '../theme/app_typography.dart';

enum AppTextVariant { display, title, body, label, caption, mono, wordmark }

/// The only way screens render text, so the type scale stays in one place.
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    this.variant = AppTextVariant.body,
    this.color,
    this.align,
    this.maxLines,
    super.key,
  });

  final String text;
  final AppTextVariant variant;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;

  TextStyle get _style => switch (variant) {
    AppTextVariant.display => AppTypography.display,
    AppTextVariant.title => AppTypography.title,
    AppTextVariant.body => AppTypography.body,
    AppTextVariant.label => AppTypography.label,
    AppTextVariant.caption => AppTypography.caption,
    AppTextVariant.mono => AppTypography.mono,
    AppTextVariant.wordmark => AppTypography.wordmark,
  };

  @override
  Widget build(BuildContext context) {
    final TextStyle style = color == null
        ? _style
        : _style.copyWith(color: color);
    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}
