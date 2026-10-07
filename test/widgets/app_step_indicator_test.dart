import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/widgets/app_step_indicator.dart';

void main() {
  testWidgets('shows every step, ticks the done ones and reports taps on them', (tester) async {
    int? tapped;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: AppStepIndicator(labels: const ['A', 'B', 'C'], current: 1, onTap: (i) => tapped = i)),
    ));

    expect(find.text('A'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget); // step A is done
    expect(find.text('3'), findsOneWidget); // step C still numbered

    await tester.tap(find.text('A'));
    expect(tapped, 0);

    await tester.tap(find.text('C'));
    expect(tapped, 0); // future steps are not tappable
  });
}
