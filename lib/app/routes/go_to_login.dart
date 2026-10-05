import 'package:get/get.dart';
import 'app_routes.dart';

/// Shows the login screen, unless it is already showing. Opening it twice in a row (e.g. the
/// token refresh and the splash screen both reacting to an expired session) makes GetX hand the
/// second page the first page's controller and then dispose it, breaking the text fields.
void goToLogin() {
  if (Get.currentRoute == AppRoutes.login) return;
  Get.offAllNamed(AppRoutes.login);
}
