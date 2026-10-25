import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/sized_asset_image.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/carbon_panel.dart';
import '../../../catalog/domain/entities/device.dart';

class PickCard extends StatelessWidget {
  const PickCard({
    required this.device,
    required this.reason,
    required this.onXray,
    super.key,
  });

  final Device device;
  final String reason;
  final VoidCallback onXray;

  @override
  Widget build(BuildContext context) {
    return CarbonPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const AppText('PICKED FOR YOU', variant: AppTextVariant.mono),
          const SizedBox(height: AppSpacing.xxs),
          AppText(reason, variant: AppTextVariant.caption),
          Center(
            child: Hero(
              tag: device.id,
              child: SizedAssetImage(
                device.asset,
                size: AppSizes.heroImage * 0.78,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(device.name, variant: AppTextVariant.title),
                    AppText(
                      '${device.tagline}  ·  ${device.battery}',
                      variant: AppTextVariant.caption,
                    ),
                  ],
                ),
              ),
              AppText(
                device.price,
                variant: AppTextVariant.label,
                color: AppColors.haloMint,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            key: const Key('open-xray'),
            label: 'Look inside · X-Ray',
            icon: Icons.blur_on,
            onPressed: onXray,
          ),
        ],
      ),
    );
  }
}
