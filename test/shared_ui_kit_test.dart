import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_ui_kit/shared_ui_kit.dart';

void main() {
  testWidgets('LoaderButton shows a spinner when isLoading is true',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: SharedUiTheme(
          data: SharedUiThemeData.light,
          child: Scaffold(
            body: LoaderButton(
              label: 'Save',
              isLoading: true,
              onPressed: () => taps++,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Save'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.byType(LoaderButton));
    expect(taps, 0, reason: 'taps should be ignored while loading');
  });

  testWidgets('LoaderButton invokes onPressed in idle state', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: SharedUiTheme(
          data: SharedUiThemeData.light,
          child: Scaffold(
            body: LoaderButton(label: 'Save', onPressed: () => taps++),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(LoaderButton));
    expect(taps, 1);
  });
}
