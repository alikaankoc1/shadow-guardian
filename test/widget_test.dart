import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadow_guardian/game/shadow_game.dart';
import 'package:shadow_guardian/models/game_world.dart';
import 'package:shadow_guardian/models/stage_config.dart';
import 'package:shadow_guardian/overlays/stage_select_overlay.dart';
import 'package:shadow_guardian/overlays/start_menu_overlay.dart';
import 'package:shadow_guardian/overlays/world_select_overlay.dart';
import 'package:shadow_guardian/theme/app_theme.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('opens start, world and stage menus in order', (tester) async {
    final game = _MenuTestGame();
    tester.view.physicalSize = const Size(1000, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: StartMenuOverlay(game: game),
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('Shadow\nGuardian'), findsOneWidget);
    expect(find.text('Oyuna Başla'), findsOneWidget);

    await tester.tap(find.text('Oyuna Başla'));
    expect(game.playTapped, isTrue);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: WorldSelectOverlay(game: game),
      ),
    );
    await _pumpFrames(tester);
    expect(find.text('Bir dünya seç'), findsOneWidget);
    expect(find.text('Doğa Dünyası'), findsOneWidget);
    expect(find.text('Araçlar'), findsOneWidget);
    expect(find.text('Çıraklık Sınavı'), findsOneWidget);
    expect(find.text('Kalfalık'), findsOneWidget);

    await tester.tap(find.text('Doğa Dünyası'));
    expect(game.natureTapped, isTrue);

    await tester.scrollUntilVisible(
      find.text('Ustalık'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ustalık'), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: StageSelectOverlay(game: game),
      ),
    );
    await _pumpFrames(tester);

    expect(find.text('SEVİYE 1'), findsOneWidget);
    expect(find.text('SEVİYE 2'), findsOneWidget);
    expect(find.text('SEVİYE 3'), findsOneWidget);

    await tester.tap(find.text('SEVİYE 1'));
    expect(game.selectedStage?.number, 1);
  });
}

Future<void> _pumpFrames(WidgetTester tester) async {
  for (var index = 0; index < 20; index++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class _MenuTestGame extends ShadowGame {
  bool playTapped = false;
  bool natureTapped = false;
  StageConfig? selectedStage;

  @override
  void startGame() {
    playTapped = true;
  }

  @override
  void openWorld(GameWorld world) {
    natureTapped = true;
    currentWorld = world;
  }

  @override
  Future<void> startStage(StageConfig stage) async {
    selectedStage = stage;
  }
}
