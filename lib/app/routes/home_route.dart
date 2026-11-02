import 'app_routes.dart';

/// The first screen after sign-in or start-up: people still registering see their registration,
/// members the dashboard.
String homeRouteFor(String? accountType) => accountType == 'applicant' ? AppRoutes.registration : AppRoutes.dashboard;
