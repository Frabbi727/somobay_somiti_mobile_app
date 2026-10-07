import 'package:get/get.dart';
import 'app_routes.dart';

// Splash & Startup
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/view/splash_page.dart';

// Auth
import '../../modules/authentication/login/bindings/login_binding.dart';
import '../../modules/authentication/login/view/login_page.dart';

// Dashboard & Core Tabs
import '../../modules/dashboard/bindings/dashboard_binding.dart';
import '../../modules/dashboard/view/dashboard_page.dart';

// Payments
import '../../modules/payments/bindings/payments_binding.dart';
import '../../modules/payments/view/pay_online_page.dart';
import '../../modules/payments/view/payment_detail_page.dart';

// Shares
import '../../modules/share_capital/bindings/shares_binding.dart';
import '../../modules/share_capital/view/share_overview_page.dart';

// Notifications (SMS history)
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/view/notification_page.dart';

// Profile & Settings
import '../../modules/profile_settings/bindings/profile_binding.dart';
import '../../modules/profile_settings/view/language_selection_page.dart';
import '../../modules/profile_settings/view/change_password_page.dart';
import '../../modules/profile_settings/view/dividends_page.dart';
import '../../modules/profile_settings/view/somiti_info_page.dart';

// Registration
import '../../modules/registration/bindings/registration_binding.dart';
import '../../modules/registration/view/registration_status_page.dart';

/// Only member features the backend supports are registered (docs/MEMBER_NAVIGATION.md).
class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.payOnline,
      page: () => const PayOnlinePage(),
      binding: PayOnlineBinding(),
    ),
    GetPage(
      name: AppRoutes.paymentDetail,
      page: () => const PaymentDetailPage(),
      binding: PaymentDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.shareOverview,
      page: () => const ShareOverviewPage(),
      binding: SharesBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationPage(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: AppRoutes.dividends,
      page: () => const DividendsPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.language,
      page: () => const LanguageSelectionPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePasswordPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.somitiInfo,
      page: () => const SomitiInfoPage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.registration,
      page: () => const RegistrationStatusPage(),
      binding: RegistrationStatusBinding(),
    ),
  ];
}
