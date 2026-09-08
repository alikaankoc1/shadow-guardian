import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_guardian/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('opens start, world and stage menus in order', (tester) async {
    tester.view.physicalSize = const Size(1000, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ShadowGuardianApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Shadow\nGuardian'), findsOneWidget);
    expect(find.text('Oyuna Başla'), findsOneWidget);

    await tester.tap(find.text('Oyuna Başla'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Bir dünya seç'), findsOneWidget);
    expect(find.text('Doğa Dünyası'), findsOneWidget);
    expect(find.text('Araçlar'), findsOneWidget);

    await tester.tap(find.text('Doğa Dünyası'));
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('SEVİYE 1'), findsOneWidget);
    expect(find.text('SEVİYE 2'), findsOneWidget);
    expect(find.text('SEVİYE 3'), findsOneWidget);
  });
}
