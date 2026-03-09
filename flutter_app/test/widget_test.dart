import 'package:flutter_app/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash transitions to onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PetFitApp()));

    expect(find.text('PetFit AI'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.text('Next'), findsOneWidget);
  });
}
