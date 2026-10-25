import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../cubit/onboarding_state.dart';

/// Slides in once when first built; the content is a const-friendly child.
class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final bool me = message.fromUser;
    final Widget bubble = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 290),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: me ? AppColors.haloMint : AppColors.carbonRaised,
          borderRadius: me ? AppRadii.bubbleOut : AppRadii.bubbleIn,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: AppText(
            message.text,
            color: me ? AppColors.obsidian : AppColors.mist,
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: me ? Alignment.centerRight : Alignment.centerLeft,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: AppDurations.medium,
          curve: Curves.easeOutCubic,
          child: bubble,
          builder: (BuildContext context, double t, Widget? child) => Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset((me ? 24 : -24) * (1 - t), 8 * (1 - t)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
