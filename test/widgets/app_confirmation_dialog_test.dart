import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/theme/app_theme.dart';
import 'package:somobay_somiti_mobile_app/core/widgets/app_dialogs.dart';

void main() {
  testWidgets('the confirmation dialog lays out with the app theme (pay-online summary)', (tester) async {
    await tester.pumpWidget(GetMaterialApp(theme: AppTheme.lightTheme, home: const Scaffold()));

    AppConfirmationDialog.show(
      title: 'Check the payment',
      message: 'Method: bKash\nAmount: 1900\nTrxID: ABC123XYZ\nDate: 05 Oct 2026',
      confirmText: 'Send',
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('common_cancel'), findsOneWidget); // the outlined button, which used to fail
  });
}
