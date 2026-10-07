class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  // Self-registration (docs/MEMBER_NAVIGATION.md)
  static const String registration = '/registration';
  static const String registrationForm = '/registration/form';

  // Member pages (docs/MEMBER_NAVIGATION.md)
  static const String payOnline = '/payments/pay-online';
  static const String paymentDetail = '/payments/detail';
  static const String shareOverview = '/shares';
  static const String notifications = '/notifications';
  static const String dividends = '/profile/dividends';
  static const String somitiInfo = '/profile/somiti-info';
  static const String language = '/profile/language';
  static const String changePassword = '/profile/change-password';
  static const String editProfile = '/profile/edit';

  // Hidden: no backend support (docs/MEMBER_FEATURES.md). Not registered in AppPages, so they
  // cannot be opened; the constants stay only because the kept, unused screens refer to them.
  static const String forceUpdate = '/force-update';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String savingsDetails = '/savings/details';
  static const String newDeposit = '/savings/deposit';
  static const String loanDetails = '/loans/details';
  static const String loanCalculator = '/loans/calculator';
  static const String loanRepay = '/loans/repay';
  static const String members = '/members';
  static const String memberDetails = '/members/details';
  static const String transactionDetails = '/transactions/details';
}
