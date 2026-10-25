import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../listener/domain/entities/listener_profile.dart';
import '../../../listener/presentation/cubit/listener_cubit.dart';
import '../../domain/entities/eq_curve.dart';
import '../../domain/services/sound_shape.dart';
import '../widgets/live_wave.dart';

/// "Tuning your SONVEIL…": a flat line bends into your sound, the five
/// bands rise, then home opens.
class TuningPage extends StatefulWidget {
  const TuningPage({super.key});

  @override
  State<TuningPage> createState() => _TuningPageState();
}

class _TuningPageState extends State<TuningPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppDurations.tuning,
  );

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(() {
      if (mounted) Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListenerProfile p = context.read<ListenerCubit>().state;
    final EqCurve target = SoundShape.presetFor(p.taste);
    final Animation<double> bend = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.1, 0.7, curve: Curves.easeInOutCubic),
    );
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const AppText(AppStrings.tuning, variant: AppTextVariant.title),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                'For ${p.name} · ${p.taste.label} · ${p.place.label}',
                variant: AppTextVariant.mono,
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedBuilder(
                animation: bend,
                builder: (BuildContext context, Widget? _) {
                  final EqCurve now = SoundShape.lerp(
                    EqCurve.flat,
                    target,
                    bend.value,
                  );
                  return Column(
                    children: <Widget>[
                      LiveWave(curve: now, height: 120),
                      const SizedBox(height: AppSpacing.xl),
                      _Bars(curve: now, rise: bend.value),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bars extends StatelessWidget {
  const _Bars({required this.curve, required this.rise});

  final EqCurve curve;
  final double rise;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < curve.gains.length; i++)
          Column(
            children: <Widget>[
              Container(
                width: 18,
                height: 12 + (curve.gains[i] + EqCurve.maxDb) * 7 * rise,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    AppColors.hairline,
                    AppColors.haloMint,
                    rise,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(EqCurve.bands[i], variant: AppTextVariant.caption),
            ],
          ),
      ],
    );
  }
}
