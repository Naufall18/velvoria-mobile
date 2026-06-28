// Widget tests for the shared PrimaryButton. Kept deterministic (no app boot,
// timers, or platform plugins) so it runs reliably in CI.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:velvoria/shared/widgets/buttons/primary_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('PrimaryButton renders its label', (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      PrimaryButton(text: 'Checkout', onPressed: () {}),
    ));

    expect(find.text('Checkout'), findsOneWidget);
  });

  testWidgets('PrimaryButton fires onPressed when tapped', (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(_wrap(
      PrimaryButton(text: 'Buy now', onPressed: () => tapped = true),
    ));

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('PrimaryButton shows a loader and is disabled while loading',
      (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(_wrap(
      PrimaryButton(text: 'Loading', isLoading: true, onPressed: () => tapped = true),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsNothing);

    await tester.tap(find.byType(PrimaryButton));
    await tester.pump();

    expect(tapped, isFalse);
  });
}
