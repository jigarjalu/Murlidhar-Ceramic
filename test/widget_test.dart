import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:murlidhar_ceramic/main.dart';

void main() {
  testWidgets('App smoke test - verifies app launches without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MurlidharCeramicApp(),
      ),
    );

    // Initial frame pump and settle the splash timer
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.byType(MurlidharCeramicApp), findsOneWidget);
  });
}
