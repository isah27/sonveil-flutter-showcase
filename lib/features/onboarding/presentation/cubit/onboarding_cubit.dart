import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../listener/domain/entities/listener_profile.dart';
import 'onboarding_state.dart';

/// A sound-check conversation: the app asks, you tap a reply.
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({this.typingDelay = const Duration(milliseconds: 650)})
    : super(const OnboardingState());

  /// How long the "typing" dots show before a question. Zero in tests.
  final Duration typingDelay;

  Future<void> start() => _ask(
    "Hi, I'm SONVEIL. Let's tune your sound in four quick taps. "
    'First, what should I call you?',
  );

  Future<void> answerName(String raw) async {
    if (state.step != OnboardingStep.name) return;
    final String name = raw.trim();
    _say(name.isEmpty ? 'Skip my name' : name);
    emit(state.copyWith(name: name, step: OnboardingStep.place));
    final String who = state.profile.name;
    await _ask('Nice to meet you, $who. Where do you listen most?');
  }

  Future<void> answerPlace(ListenPlace place) async {
    if (state.step != OnboardingStep.place) return;
    _say(place.label);
    emit(state.copyWith(place: place, step: OnboardingStep.listenFor));
    await _ask('Got it. And what fills your ears?');
  }

  Future<void> answerListenFor(ListenFor value) async {
    if (state.step != OnboardingStep.listenFor) return;
    _say(value.label);
    emit(state.copyWith(listenFor: value, step: OnboardingStep.taste));
    await _ask('Last one. How do you like it to sound?');
  }

  Future<void> answerTaste(SoundTaste taste) async {
    if (state.step != OnboardingStep.taste) return;
    _say(taste.label);
    emit(state.copyWith(taste: taste, step: OnboardingStep.done));
    await _ask(
      'Perfect, ${state.profile.name}. ${taste.label} it is. '
      "I'll build your home around that.",
    );
  }

  void _say(String text) => emit(
    state.copyWith(
      messages: <ChatMessage>[
        ...state.messages,
        ChatMessage(text, fromUser: true),
      ],
    ),
  );

  Future<void> _ask(String text) async {
    emit(state.copyWith(typing: true));
    if (typingDelay > Duration.zero) await Future<void>.delayed(typingDelay);
    if (isClosed) return;
    emit(
      state.copyWith(
        typing: false,
        messages: <ChatMessage>[...state.messages, ChatMessage(text)],
      ),
    );
  }
}
