import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/sized_asset_image.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/carbon_panel.dart';
import '../../../catalog/domain/entities/device.dart';

class RangeTile extends StatelessWidget {
  const RangeTile({required this.device, required this.onTap, super.key});

  final Device device;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadii.lg,
      onTap: onTap,
      child: CarbonPanel(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: <Widget>[
            SizedAssetImage(device.asset, size: AppSizes.tileImage),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(device.name, variant: AppTextVariant.label),
                  AppText(
                    device.tagline,
                    variant: AppTextVariant.caption,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(device.price, variant: AppTextVariant.mono),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
