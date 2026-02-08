import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/screens/config_screen.dart';

void main() {
  testWidgets('ConfigScreen shows validation messages', (
    WidgetTester tester,
  ) async {
    bool started = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ConfigScreen(
          onStart: (config) {
            started = true;
          },
        ),
      ),
    );

    // Clear the exercise count to trigger validation
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.text('Başlat'));
    await tester.pumpAndSettle();

    expect(find.text('Lütfen bir değer girin'), findsWidgets);

    // Enter invalid counts and durations
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '1'); // ex count <2
    await tester.enterText(
      fields.at(1),
      '2',
    ); // ex duration (valid >=3?) this is 2 invalid
    await tester.enterText(fields.at(2), '1'); // set count <2
    await tester.enterText(fields.at(3), '2'); // rest between ex invalid
    await tester.enterText(fields.at(4), '2'); // rest between sets invalid

    await tester.tap(find.text('Başlat'));
    await tester.pumpAndSettle();

    expect(find.text('Minimum 2 olmalı'), findsNWidgets(2));
    expect(find.text('Minimum 3 saniye olmalı'), findsNWidgets(3));
    expect(started, isFalse);
  });
}
