import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/demo/demo_tour.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/carbon_panel.dart';
import '../../../catalog/domain/entities/device.dart';
import '../cubit/xray_cubit.dart';
import '../demo/xray_tour.dart';
import '../widgets/xray_stage.dart';

class XrayPage extends StatelessWidget {
  const XrayPage({required this.device, super.key});

  final Device device;

  @override
  Widget build(BuildContext context) => BlocProvider<XrayCubit>(
    create: (_) => XrayCubit(),
    child: _XrayView(device: device),
  );
}

class _XrayView extends StatefulWidget {
  const _XrayView({required this.device});

  final Device device;

  @override
  State<_XrayView> createState() => _XrayViewState();
}

class _XrayViewState extends State<_XrayView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _explode = AnimationController(
    vsync: this,
    duration: AppDurations.explode,
  );

  @override
  void initState() {
    super.initState();
    if (DemoTour.enabled) {
      XrayTour(_explode, context.read<XrayCubit>(), _openSculpt).run();
    }
  }

  @override
  void dispose() {
    _explode.dispose();
    super.dispose();
  }

  Future<void> _openSculpt() => Navigator.of(
    context,
  ).pushNamed(AppRoutes.sculpt, arguments: widget.device);

  void _toggle() {
    context.read<XrayCubit>().clear();
    _explode.animateTo(
      _explode.value > 0.5 ? 0 : 1,
      duration: AppDurations.explode,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Device d = widget.device;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        title: const AppText('X-RAY', variant: AppTextVariant.mono),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: <Widget>[
          AppText(d.name, variant: AppTextVariant.display),
          AppText(
            '${d.tagline}  ·  ${d.price}',
            variant: AppTextVariant.caption,
          ),
          XrayStage(device: d, explode: _explode),
          const Center(
            child: AppText(
              AppStrings.xrayHint,
              variant: AppTextVariant.caption,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          BlocBuilder<XrayCubit, int?>(
            builder: (BuildContext context, int? i) => AnimatedSwitcher(
              duration: AppDurations.fast,
              child: CarbonPanel(
                key: ValueKey<int?>(i),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.memory, color: AppColors.haloMint),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AppText(
                            i == null
                                ? '${d.layers.length} parts inside'
                                : d.layers[i].name,
                            variant: AppTextVariant.label,
                          ),
                          AppText(
                            i == null
                                ? 'Open it, then tap a part'
                                : d.layers[i].spec,
                            variant: AppTextVariant.mono,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: AppButton(
                  key: const Key('explode'),
                  label: 'Open / close',
                  variant: AppButtonVariant.ghost,
                  onPressed: _toggle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  key: const Key('open-sculpt'),
                  label: 'Sculpt sound',
                  onPressed: _openSculpt,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
