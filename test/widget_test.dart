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

    // Initial frame pump
    await tester.pump();
    // Advance past the 2.8s splash timer
    await tester.pump(const Duration(milliseconds: 3000));
    expect(find.byType(MurlidharCeramicApp), findsOneWidget);
  });
}
