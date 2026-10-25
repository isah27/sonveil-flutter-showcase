import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/demo/demo_tour.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../listener/domain/entities/listener_profile.dart';
import '../../../listener/presentation/cubit/listener_cubit.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../demo/onboarding_tour.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/reply_bar.dart';
import '../widgets/typing_dots.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({this.typingDelay, super.key});

  final Duration? typingDelay;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnboardingCubit>(
      create: (_) =>
          (typingDelay == null
                ? OnboardingCubit()
                : OnboardingCubit(typingDelay: typingDelay!))
            ..start(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final TextEditingController _name = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    if (DemoTour.enabled) {
      OnboardingTour(context.read<OnboardingCubit>(), _name, _finish).run();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Skip and Finish share one way out, and replace the route so back
  /// never returns to the questions.
  void _leave(ListenerProfile profile, String route) {
    context.read<ListenerCubit>().save(profile);
    Navigator.of(context).pushReplacementNamed(route);
  }

  void _skip() => _leave(ListenerProfile.defaults, AppRoutes.home);

  void _finish() =>
      _leave(context.read<OnboardingCubit>().state.profile, AppRoutes.tuning);

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.xs,
                0,
              ),
              child: Row(
                children: <Widget>[
                  const BrandWordmark(),
                  const SizedBox(width: AppSpacing.sm),
                  const Flexible(
                    child: AppText(
                      'Sound check',
                      variant: AppTextVariant.mono,
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    key: const Key('skip'),
                    onPressed: _skip,
                    child: const AppText(
                      AppStrings.skip,
                      variant: AppTextVariant.label,
                      color: AppColors.haloMint,
                    ),
                  ),
                ],
              ),
            ),
            BlocSelector<OnboardingCubit, OnboardingState, double>(
              selector: (OnboardingState s) => s.progress,
              builder: (BuildContext context, double p) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: p),
                  duration: const Duration(milliseconds: 400),
                  builder: (BuildContext context, double v, Widget? _) =>
                      LinearProgressIndicator(
                        value: v,
                        minHeight: 3,
                        color: AppColors.haloMint,
                        backgroundColor: AppColors.hairline,
                      ),
                ),
              ),
            ),
            Expanded(
              child: BlocConsumer<OnboardingCubit, OnboardingState>(
                listener: (BuildContext context, OnboardingState s) =>
                    _scrollToEnd(),
                buildWhen: (OnboardingState a, OnboardingState b) =>
                    a.messages != b.messages || a.typing != b.typing,
                builder: (BuildContext context, OnboardingState s) =>
                    ListView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: s.messages.length + (s.typing ? 1 : 0),
                      itemBuilder: (BuildContext context, int i) =>
                          i == s.messages.length
                          ? const TypingDots()
                          : ChatBubble(
                              key: ValueKey<int>(i),
                              message: s.messages[i],
                            ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xs,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: ReplyBar(nameController: _name, onFinish: _finish),
            ),
          ],
        ),
      ),
    );
  }
}
