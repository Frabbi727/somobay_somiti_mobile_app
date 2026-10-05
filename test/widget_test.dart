import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/theme/app_colors.dart';
import 'package:somobay_somiti_mobile_app/core/widgets/app_buttons.dart';
import 'package:somobay_somiti_mobile_app/core/widgets/app_card.dart';

void main() {
  testWidgets('AppPrimaryButton renders and triggers callback', (WidgetTester tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: AppButton.primary(
            text: 'নিশ্চিত করুন',
            onPressed: () {
              wasPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('নিশ্চিত করুন'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(wasPressed, isTrue);
  });

  testWidgets('AppCard renders child content', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: AppCard(
            child: Text('সমিতি সঞ্চয়'),
          ),
        ),
      ),
    );

    expect(find.text('সমিতি সঞ্চয়'), findsOneWidget);
  });
}
