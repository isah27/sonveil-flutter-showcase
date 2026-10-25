import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonveil/app.dart';

Future<void> settle(WidgetTester t, [int ms = 1000]) async {
  for (int i = 0; i < ms ~/ 100; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  Future<void> boot(WidgetTester t) async {
    t.view.physicalSize = const Size(412, 915);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(const SonveilApp());
    await settle(t);
  }

  testWidgets('Skip lands on a default home', (WidgetTester t) async {
    await boot(t);
    expect(find.byKey(const Key('skip')), findsOneWidget);
    await t.tap(find.byKey(const Key('skip')));
    await settle(t);
    expect(find.textContaining('Listener.'), findsOneWidget);
    expect(find.textContaining('Answer a few questions'), findsOneWidget);
  });

  testWidgets('sound check personalises the home', (WidgetTester t) async {
    await boot(t);
    await t.enterText(find.byKey(const Key('name-field')), 'Isah');
    await t.tap(find.byKey(const Key('send-name')));
    await settle(t);
    for (final String k in <String>[
      'ListenPlace.studio',
      'ListenFor.music',
      'SoundTaste.warm',
    ]) {
      await t.tap(find.byKey(Key('reply-$k')));
      await settle(t);
    }
    await t.tap(find.byKey(const Key('finish')));
    await settle(t, 4500); // tuning reveal, then home
    expect(find.textContaining('Isah.'), findsOneWidget);
    expect(find.textContaining('Your Warm Halo One is tuned.'), findsOneWidget);
    expect(find.byKey(const Key('open-xray')), findsOneWidget);
  });

  testWidgets('X-Ray opens from home and drags apart', (WidgetTester t) async {
    await boot(t);
    await t.tap(find.byKey(const Key('skip')));
    await settle(t);
    await t.tap(find.byKey(const Key('open-xray')));
    await settle(t);
    expect(find.byKey(const Key('xray-stage')), findsOneWidget);
    await t.drag(find.byKey(const Key('xray-stage')), const Offset(0, -300));
    await settle(t);
    expect(find.textContaining('parts inside'), findsOneWidget);
    await t.tap(find.byKey(const Key('open-sculpt')));
    await settle(t);
    expect(find.textContaining('Save to'), findsWidgets);
  });
}
