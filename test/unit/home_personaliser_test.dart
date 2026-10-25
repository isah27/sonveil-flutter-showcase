import 'package:flutter_test/flutter_test.dart';
import 'package:sonveil/features/catalog/data/repositories/local_device_repository.dart';
import 'package:sonveil/features/catalog/domain/entities/device.dart';
import 'package:sonveil/features/home/domain/entities/home_briefing.dart';
import 'package:sonveil/features/home/domain/services/home_personaliser.dart';
import 'package:sonveil/features/listener/domain/entities/listener_profile.dart';

void main() {
  final List<Device> devices = const LocalDeviceRepository().all();
  ListenerProfile p(ListenPlace place, ListenFor f) => ListenerProfile(
    name: 'Isah',
    place: place,
    listenFor: f,
    taste: SoundTaste.warm,
  );

  test('greeting follows the clock', () {
    expect(HomePersonaliser.greetingFor(3), 'Late night');
    expect(HomePersonaliser.greetingFor(9), 'Good morning');
    expect(HomePersonaliser.greetingFor(14), 'Good afternoon');
    expect(HomePersonaliser.greetingFor(21), 'Good evening');
  });

  test('answers decide the lead device', () {
    expect(
      HomePersonaliser.kindFor(p(ListenPlace.gym, ListenFor.music)),
      DeviceKind.earbuds,
    );
    expect(
      HomePersonaliser.kindFor(p(ListenPlace.studio, ListenFor.calls)),
      DeviceKind.earbuds,
    );
    expect(
      HomePersonaliser.kindFor(p(ListenPlace.home, ListenFor.music)),
      DeviceKind.speaker,
    );
    expect(
      HomePersonaliser.kindFor(p(ListenPlace.studio, ListenFor.music)),
      DeviceKind.overEar,
    );
  });

  test('briefing greets by name and never repeats the pick', () {
    final HomeBriefing b = HomePersonaliser.brief(
      profile: p(ListenPlace.studio, ListenFor.music),
      devices: devices,
      hour: 20,
    );
    expect(b.greeting, 'Good evening, Isah.');
    expect(b.headline, 'Your Warm ${b.pick.name} is tuned.');
    expect(b.others, isNot(contains(b.pick)));
    expect(b.others.length, devices.length - 1);
  });

  test('skipped profile is honest about it', () {
    final HomeBriefing b = HomePersonaliser.brief(
      profile: ListenerProfile.defaults,
      devices: devices,
      hour: 10,
    );
    expect(b.greeting, 'Good morning, Listener.');
    expect(b.reason, contains('Answer a few questions'));
  });
}
