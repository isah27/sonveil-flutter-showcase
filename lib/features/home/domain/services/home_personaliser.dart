import '../../../catalog/domain/entities/device.dart';
import '../../../listener/domain/entities/listener_profile.dart';
import '../entities/home_briefing.dart';

/// Pure: answers in, home copy out. No widget decides any of this.
abstract final class HomePersonaliser {
  static String greetingFor(int hour) => switch (hour) {
    < 5 => 'Late night',
    < 12 => 'Good morning',
    < 17 => 'Good afternoon',
    _ => 'Good evening',
  };

  /// Where and what you listen to decides which device leads.
  static DeviceKind kindFor(ListenerProfile p) {
    if (p.place == ListenPlace.gym || p.listenFor == ListenFor.calls) {
      return DeviceKind.earbuds;
    }
    if (p.place == ListenPlace.home) return DeviceKind.speaker;
    return DeviceKind.overEar;
  }

  static HomeBriefing brief({
    required ListenerProfile profile,
    required List<Device> devices,
    required int hour,
  }) {
    final DeviceKind kind = kindFor(profile);
    final Device pick = devices.firstWhere((Device d) => d.kind == kind);
    final List<Device> others = <Device>[
      for (final Device d in devices)
        if (d != pick) d,
    ];
    final String reason = profile.personalised
        ? 'For ${profile.listenFor.label.toLowerCase()}, '
              '${profile.place.label.toLowerCase()}.'
        : 'Our most-loved pick. Answer a few questions to tune it.';
    return HomeBriefing(
      greeting: '${greetingFor(hour)}, ${profile.name}.',
      headline: 'Your ${profile.taste.label} ${pick.name} is tuned.',
      reason: reason,
      pick: pick,
      others: others,
    );
  }
}
