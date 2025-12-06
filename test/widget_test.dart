import 'package:flutter_test/flutter_test.dart';

import 'package:capital_race/main.dart';

void main() {
  testWidgets('Monopoly app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MonopolyApp());

    // Verify that we can see the home screen
    expect(find.text('MONOPOLY'), findsOneWidget);
    expect(find.text('NEW GAME'), findsOneWidget);
  });
}
