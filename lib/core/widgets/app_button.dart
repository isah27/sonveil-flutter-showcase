import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import 'app_text.dart';

enum AppButtonVariant { primary, ghost, chip }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expanded = true,
    this.selected = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expanded;
  final bool selected;
  final IconData? icon;

  Color get _fill => switch (variant) {
    AppButtonVariant.primary => AppColors.haloMint,
    AppButtonVariant.chip =>
      selected ? AppColors.haloMint : AppColors.carbonRaised,
    AppButtonVariant.ghost => AppColors.transparent,
  };

  Color get _ink => switch (variant) {
    AppButtonVariant.primary => AppColors.obsidian,
    AppButtonVariant.chip => selected ? AppColors.obsidian : AppColors.mist,
    AppButtonVariant.ghost => AppColors.mist,
  };

  @override
  Widget build(BuildContext context) {
    final bool chip = variant == AppButtonVariant.chip;
    return SizedBox(
      height: chip ? AppSizes.chipHeight : AppSizes.buttonHeight,
      width: expanded ? double.infinity : null,
      child: Material(
        color: _fill,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.pill,
          side: variant == AppButtonVariant.primary
              ? BorderSide.none
              : const BorderSide(color: AppColors.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: chip ? AppSpacing.md : AppSpacing.lg,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 18, color: _ink),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Flexible(
                  child: AppText(
                    label,
                    variant: AppTextVariant.label,
                    color: _ink,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
