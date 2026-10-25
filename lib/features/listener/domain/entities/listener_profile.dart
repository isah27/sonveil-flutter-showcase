import 'package:equatable/equatable.dart';

enum ListenPlace {
  commute('On the move'),
  studio('At my desk'),
  gym('Training'),
  home('At home');

  const ListenPlace(this.label);
  final String label;
}

enum ListenFor {
  music('Music'),
  podcasts('Podcasts'),
  calls('Calls'),
  gaming('Gaming');

  const ListenFor(this.label);
  final String label;
}

enum SoundTaste {
  warm('Warm', 'Rich lows, soft highs'),
  balanced('Balanced', 'Studio flat'),
  bright('Bright', 'Crisp vocals, airy highs');

  const SoundTaste(this.label, this.blurb);
  final String label;
  final String blurb;
}

class ListenerProfile extends Equatable {
  const ListenerProfile({
    required this.name,
    required this.place,
    required this.listenFor,
    required this.taste,
    this.personalised = true,
  });

  /// What Skip gives you: sensible, and honest that nothing was asked.
  static const ListenerProfile defaults = ListenerProfile(
    name: 'Listener',
    place: ListenPlace.commute,
    listenFor: ListenFor.music,
    taste: SoundTaste.balanced,
    personalised: false,
  );

  final String name;
  final ListenPlace place;
  final ListenFor listenFor;
  final SoundTaste taste;
  final bool personalised;

  @override
  List<Object?> get props => <Object?>[
    name,
    place,
    listenFor,
    taste,
    personalised,
  ];
}
