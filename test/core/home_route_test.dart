import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/app/routes/app_routes.dart';
import 'package:somobay_somiti_mobile_app/app/routes/home_route.dart';

void main() {
  test('someone still registering starts on the registration status', () {
    expect(homeRouteFor('applicant'), AppRoutes.registration);
  });

  test('members, and older backends that send no account type, start on the dashboard', () {
    expect(homeRouteFor('member'), AppRoutes.dashboard);
    expect(homeRouteFor(null), AppRoutes.dashboard);
  });
}
