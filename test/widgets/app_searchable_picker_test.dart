import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/localization/app_translations.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/core/widgets/app_searchable_picker.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/model/geo_place_model.dart';

import '../support/fixtures.dart';

List<GeoPlaceModel> _unions() =>
    (fixture('geo_unions_495')['data'] as List<dynamic>).map((row) => GeoPlaceModel.fromJson(row as Map<String, dynamic>)).toList();

Widget _app(Widget child) => GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      home: Scaffold(body: Form(child: child)),
    );

AppSearchablePicker<GeoPlaceModel> _picker({
  List<GeoPlaceModel>? items,
  bool enabled = true,
  bool isLoading = false,
  Failure? failure,
  VoidCallback? onRetry,
  ValueChanged<GeoPlaceModel?>? onChanged,
  String? Function(GeoPlaceModel?)? validator,
}) =>
    AppSearchablePicker<GeoPlaceModel>(
      label: 'Union',
      items: items ?? _unions(),
      itemLabel: (place) => place.label('en'),
      searchTerms: (place) => [place.nameBn, place.nameEn],
      onChanged: onChanged ?? (_) {},
      validator: validator,
      enabled: enabled,
      isLoading: isLoading,
      failure: failure,
      onRetry: onRetry,
    );

void main() {
  testWidgets('picker filters by bangla and english', (tester) async {
    GeoPlaceModel? chosen;
    await tester.pumpWidget(_app(_picker(onChanged: (place) => chosen = place)));

    await tester.tap(find.byKey(const Key('picker_field')));
    await tester.pumpAndSettle();
    expect(find.text('Baridhara'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('picker_search')), 'গুলশান');
    await tester.pumpAndSettle();
    expect(find.text('Gulshan-1'), findsOneWidget);
    expect(find.text('Gulshan-2'), findsOneWidget);
    expect(find.text('Baridhara'), findsNothing);

    await tester.enterText(find.byKey(const Key('picker_search')), 'GULSH');
    await tester.pumpAndSettle();
    expect(find.text('Gulshan-1'), findsOneWidget);
    expect(find.text('Gulshan-2'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('picker_search')), 'গুলশান-২');
    await tester.pumpAndSettle();
    expect(find.text('Gulshan-1'), findsNothing);
    expect(find.text('Gulshan-2'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('picker_search')), 'xyz');
    await tester.pumpAndSettle();
    expect(find.text('Gulshan-1'), findsNothing);
    expect(find.text('No matches'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('picker_search')), 'gulshan-1');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gulshan-1'));
    await tester.pumpAndSettle();

    expect(chosen?.id, 4541);
    expect(find.byKey(const Key('picker_search')), findsNothing, reason: 'the sheet closes after choosing');
    expect(find.text('Gulshan-1'), findsOneWidget, reason: 'the field shows the choice');
  });

  testWidgets('picker is disabled without a parent', (tester) async {
    await tester.pumpWidget(_app(_picker(enabled: false, items: const [])));

    await tester.tap(find.byKey(const Key('picker_field')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('picker_search')), findsNothing);
  });

  testWidgets('an empty list shows an empty state, not an error', (tester) async {
    await tester.pumpWidget(_app(_picker(items: const [])));

    await tester.tap(find.byKey(const Key('picker_field')));
    await tester.pumpAndSettle();

    expect(find.text('Nothing to choose here'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('shows a loading state while the list is fetched', (tester) async {
    await tester.pumpWidget(_app(_picker(isLoading: true, items: const [])));
    await tester.tap(find.byKey(const Key('picker_field')));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text('Nothing to choose here'), findsNothing);
  });

  testWidgets('shows an error with a retry button', (tester) async {
    var retried = 0;
    await tester.pumpWidget(_app(_picker(failure: const NetworkFailure(), items: const [], onRetry: () => retried++)));
    await tester.pump();
    await tester.tap(find.byKey(const Key('picker_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    expect(retried, 1);
  });

  testWidgets('validator error shows under the field', (tester) async {
    final key = GlobalKey<FormState>();
    await tester.pumpWidget(GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      home: Scaffold(body: Form(key: key, child: _picker(validator: (place) => place == null ? 'Required' : null))),
    ));

    key.currentState!.validate();
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });
}
