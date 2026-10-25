import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/demo/demo_tour.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/carbon_panel.dart';
import '../../../catalog/domain/entities/device.dart';
import '../../../listener/domain/entities/listener_profile.dart';
import '../../../listener/presentation/cubit/listener_cubit.dart';
import '../../domain/entities/eq_curve.dart';
import '../cubit/sculpt_cubit.dart';
import '../demo/sculpt_tour.dart';
import '../widgets/eq_canvas.dart';
import '../widgets/live_wave.dart';

class SculptPage extends StatelessWidget {
  const SculptPage({required this.device, super.key});

  final Device device;

  @override
  Widget build(BuildContext context) {
    final SoundTaste taste = context.read<ListenerCubit>().state.taste;
    return BlocProvider<SculptCubit>(
      create: (_) => SculptCubit(taste),
      child: _SculptView(device: device),
    );
  }
}

class _SculptView extends StatefulWidget {
  const _SculptView({required this.device});

  final Device device;

  @override
  State<_SculptView> createState() => _SculptViewState();
}

class _SculptViewState extends State<_SculptView> {
  @override
  void initState() {
    super.initState();
    if (DemoTour.enabled) SculptTour(context.read<SculptCubit>()).run();
  }

  @override
  Widget build(BuildContext context) {
    final SculptCubit cubit = context.read<SculptCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.obsidian,
        title: AppText(
          'Sound Sculpt · ${widget.device.name}',
          variant: AppTextVariant.label,
        ),
      ),
      body: BlocConsumer<SculptCubit, SculptState>(
        listenWhen: (SculptState a, SculptState b) => !a.saved && b.saved,
        listener: (BuildContext context, SculptState s) =>
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.carbonRaised,
                content: AppText(
                  'Saved to your ${widget.device.name} (demo, nothing leaves the device)',
                ),
              ),
            ),
        builder: (BuildContext context, SculptState s) => ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            CarbonPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AppText(
                    s.preset == null
                        ? 'CUSTOM SOUND'
                        : '${s.preset!.label.toUpperCase()} PRESET',
                    variant: AppTextVariant.mono,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  LiveWave(curve: s.curve, height: 90),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppText(
              AppStrings.sculptHint,
              variant: AppTextVariant.caption,
            ),
            const SizedBox(height: AppSpacing.md),
            EqCanvas(curve: s.curve, onDrag: cubit.drag),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for (final String b in EqCurve.bands)
                  AppText('$b Hz', variant: AppTextVariant.caption),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.xs,
              children: <Widget>[
                for (final SoundTaste t in SoundTaste.values)
                  AppButton(
                    key: Key('preset-${t.name}'),
                    label: t.label,
                    variant: AppButtonVariant.chip,
                    selected: s.preset == t,
                    expanded: false,
                    onPressed: () => cubit.applyPreset(t),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Save to ${widget.device.name}',
              onPressed: cubit.save,
            ),
          ],
        ),
      ),
    );
  }
}
