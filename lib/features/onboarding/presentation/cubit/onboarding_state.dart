import 'package:equatable/equatable.dart';

import '../../../listener/domain/entities/listener_profile.dart';

enum OnboardingStep { name, place, listenFor, taste, done }

class ChatMessage extends Equatable {
  const ChatMessage(this.text, {this.fromUser = false});

  final String text;
  final bool fromUser;

  @override
  List<Object?> get props => <Object?>[text, fromUser];
}

class OnboardingState extends Equatable {
  const OnboardingState({
    this.step = OnboardingStep.name,
    this.messages = const <ChatMessage>[],
    this.typing = false,
    this.name,
    this.place,
    this.listenFor,
    this.taste,
  });

  final OnboardingStep step;
  final List<ChatMessage> messages;
  final bool typing;
  final String? name;
  final ListenPlace? place;
  final ListenFor? listenFor;
  final SoundTaste? taste;

  /// Answers so far, with defaults for anything skipped.
  ListenerProfile get profile {
    final String cleaned = (name ?? '').trim();
    return ListenerProfile(
      name: cleaned.isEmpty
          ? ListenerProfile.defaults.name
          : cleaned[0].toUpperCase() + cleaned.substring(1),
      place: place ?? ListenerProfile.defaults.place,
      listenFor: listenFor ?? ListenerProfile.defaults.listenFor,
      taste: taste ?? ListenerProfile.defaults.taste,
    );
  }

  double get progress => step.index / OnboardingStep.done.index;

  OnboardingState copyWith({
    OnboardingStep? step,
    List<ChatMessage>? messages,
    bool? typing,
    String? name,
    ListenPlace? place,
    ListenFor? listenFor,
    SoundTaste? taste,
  }) => OnboardingState(
    step: step ?? this.step,
    messages: messages ?? this.messages,
    typing: typing ?? this.typing,
    name: name ?? this.name,
    place: place ?? this.place,
    listenFor: listenFor ?? this.listenFor,
    taste: taste ?? this.taste,
  );

  @override
  List<Object?> get props => <Object?>[
    step,
    messages,
    typing,
    name,
    place,
    listenFor,
    taste,
  ];
}
