import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../listener/domain/entities/listener_profile.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

/// The tappable replies for the current question.
class ReplyBar extends StatelessWidget {
  const ReplyBar({
    required this.nameController,
    required this.onFinish,
    super.key,
  });

  final TextEditingController nameController;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final OnboardingCubit cubit = context.read<OnboardingCubit>();
    final OnboardingState s = context.watch<OnboardingCubit>().state;
    if (s.typing) return const SizedBox(height: AppSizes.buttonHeight);

    final Widget child = switch (s.step) {
      OnboardingStep.name => Row(
        children: <Widget>[
          Expanded(
            child: AppTextField(
              fieldKey: const Key('name-field'),
              controller: nameController,
              hint: 'Your first name',
              onSubmitted: cubit.answerName,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          AppButton(
            key: const Key('send-name'),
            label: 'Send',
            expanded: false,
            onPressed: () => cubit.answerName(nameController.text),
          ),
        ],
      ),
      OnboardingStep.place => _chips<ListenPlace>(
        ListenPlace.values,
        (ListenPlace p) => p.label,
        cubit.answerPlace,
      ),
      OnboardingStep.listenFor => _chips<ListenFor>(
        ListenFor.values,
        (ListenFor p) => p.label,
        cubit.answerListenFor,
      ),
      OnboardingStep.taste => _chips<SoundTaste>(
        SoundTaste.values,
        (SoundTaste t) => '${t.label} · ${t.blurb}',
        cubit.answerTaste,
      ),
      OnboardingStep.done => AppButton(
        key: const Key('finish'),
        label: 'Tune my SONVEIL',
        icon: Icons.graphic_eq,
        onPressed: onFinish,
      ),
    };
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: KeyedSubtree(key: ValueKey<OnboardingStep>(s.step), child: child),
    );
  }

  Widget _chips<T>(
    List<T> values,
    String Function(T) label,
    void Function(T) onTap,
  ) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        for (final T v in values)
          AppButton(
            key: Key('reply-$v'),
            label: label(v),
            variant: AppButtonVariant.chip,
            expanded: false,
            onPressed: () => onTap(v),
          ),
      ],
    );
  }
}
