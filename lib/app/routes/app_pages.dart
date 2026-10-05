import 'package:get/get.dart';
import 'app_routes.dart';

// Splash & Startup
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/view/splash_page.dart';
import '../../modules/splash/view/force_update_page.dart';

// Auth
import '../../modules/authentication/login/bindings/login_binding.dart';
import '../../modules/authentication/login/view/login_page.dart';
import '../../modules/authentication/register/view/register_page.dart';
import '../../modules/authentication/forgot_password/view/forgot_password_page.dart';
import '../../modules/authentication/otp_verification/view/otp_verification_page.dart';

// Dashboard & Core Tabs
import '../../modules/dashboard/bindings/dashboard_binding.dart';
import '../../modules/dashboard/view/dashboard_page.dart';

// Savings
import '../../modules/savings_dps/bindings/savings_binding.dart';
import '../../modules/savings_dps/view/new_deposit_page.dart';

// Loans
import '../../modules/loans/bindings/loan_binding.dart';
import '../../modules/loans/view/loan_calculator_page.dart';
import '../../modules/loans/view/loan_repayment_page.dart';

// Shares
import '../../modules/share_capital/view/share_overview_page.dart';

// Members
import '../../modules/members/view/member_list_page.dart';

// Transactions
import '../../modules/transactions/bindings/transaction_binding.dart';
import '../../modules/transactions/view/transaction_details_page.dart';

// Notifications
import '../../modules/notifications/view/notification_page.dart';

// Profile & Settings
import '../../modules/profile_settings/bindings/profile_binding.dart';
import '../../modules/profile_settings/view/language_selection_page.dart';
import '../../modules/profile_settings/view/change_password_page.dart';
import '../../modules/profile_settings/view/somiti_info_page.dart';

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
      name: AppRoutes.forceUpdate,
      page: () => const ForceUpdatePage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () => const OtpVerificationPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.newDeposit,
      page: () => const NewDepositPage(),
      binding: SavingsBinding(),
    ),
    GetPage(
      name: AppRoutes.loanCalculator,
      page: () => const LoanCalculatorPage(),
    ),
    GetPage(
      name: AppRoutes.loanRepay,
      page: () => const LoanRepaymentPage(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: AppRoutes.shareOverview,
      page: () => const ShareOverviewPage(),
    ),
    GetPage(
      name: AppRoutes.members,
      page: () => const MemberListPage(),
    ),
    GetPage(
      name: AppRoutes.transactionDetails,
      page: () => const TransactionDetailsPage(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationPage(),
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
    ),
  ];
}
