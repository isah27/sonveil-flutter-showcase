import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/demo/demo_tour.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../../core/widgets/carbon_panel.dart';
import '../../../catalog/domain/entities/device.dart';
import '../../../catalog/domain/repositories/device_repository.dart';
import '../../../listener/domain/entities/listener_profile.dart';
import '../../../listener/presentation/cubit/listener_cubit.dart';
import '../../../tuner/domain/services/sound_shape.dart';
import '../../../tuner/presentation/widgets/live_wave.dart';
import '../../domain/entities/home_briefing.dart';
import '../../domain/services/home_personaliser.dart';
import '../widgets/pick_card.dart';
import '../widgets/range_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.hour, super.key});

  /// Injected in tests; otherwise the device clock.
  final int? hour;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (DemoTour.enabled) {
      Future<void>.delayed(const Duration(milliseconds: 3800), () {
        if (!mounted) return;
        final ListenerProfile p = context.read<ListenerCubit>().state;
        _open(AppRoutes.xray, _brief(p).pick);
      });
    }
  }

  HomeBriefing _brief(ListenerProfile p) => HomePersonaliser.brief(
    profile: p,
    devices: context.read<DeviceRepository>().all(),
    hour: widget.hour ?? DateTime.now().hour,
  );

  void _open(String route, Device d) =>
      Navigator.of(context).pushNamed(route, arguments: d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Rebuilds only when the profile changes; the briefing is a pure call.
        child: BlocBuilder<ListenerCubit, ListenerProfile>(
          builder: (BuildContext context, ListenerProfile p) {
            final HomeBriefing b = _brief(p);
            return CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverList.list(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const BrandWordmark(),
                          const Spacer(),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.haloMint,
                            child: AppText(
                              p.name[0],
                              variant: AppTextVariant.label,
                              color: AppColors.obsidian,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppText(
                        b.greeting,
                        key: const Key('greeting'),
                        variant: AppTextVariant.display,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      AppText(
                        b.headline,
                        key: const Key('headline'),
                        color: AppColors.titanium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      CarbonPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: AppText(
                                    'YOUR SOUND · ${p.taste.label.toUpperCase()}',
                                    variant: AppTextVariant.mono,
                                    maxLines: 1,
                                  ),
                                ),
                                Flexible(
                                  child: AppText(
                                    p.taste.blurb,
                                    variant: AppTextVariant.caption,
                                    maxLines: 1,
                                    align: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            LiveWave(
                              curve: SoundShape.presetFor(p.taste),
                              height: 56,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            AppButton(
                              label: 'Sculpt my sound',
                              variant: AppButtonVariant.ghost,
                              onPressed: () => _open(AppRoutes.sculpt, b.pick),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      PickCard(
                        device: b.pick,
                        reason: b.reason,
                        onXray: () => _open(AppRoutes.xray, b.pick),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const AppText(
                        'Also in the range',
                        variant: AppTextVariant.title,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverList.separated(
                    itemCount: b.others.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int i) => RangeTile(
                      key: ValueKey<String>(b.others[i].id),
                      device: b.others[i],
                      onTap: () => _open(AppRoutes.xray, b.others[i]),
                    ),
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverToBoxAdapter(
                    child: AppText(
                      AppStrings.fictional,
                      variant: AppTextVariant.caption,
                      align: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
