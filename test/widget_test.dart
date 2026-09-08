import 'package:flutter_test/flutter_test.dart';
import 'package:shadow_guardian/main.dart';

void main() {
  testWidgets('Shadow Guardian app builds', (tester) async {
    await tester.pumpWidget(const ShadowGuardianApp());
    await tester.pump();
    expect(find.byType(ShadowGuardianApp), findsOneWidget);
  });
}
