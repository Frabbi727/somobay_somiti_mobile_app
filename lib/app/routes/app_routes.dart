class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String forceUpdate = '/force-update';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String dashboard = '/dashboard';
  
  // Nested/Sub Routes
  static const String savingsDetails = '/savings/details';
  static const String newDeposit = '/savings/deposit';
  static const String loanDetails = '/loans/details';
  static const String loanCalculator = '/loans/calculator';
  static const String loanRepay = '/loans/repay';
  static const String shareOverview = '/shares';
  static const String members = '/members';
  static const String memberDetails = '/members/details';
  static const String transactionDetails = '/transactions/details';
  static const String notifications = '/notifications';
  static const String editProfile = '/profile/edit';
  static const String language = '/profile/language';
  static const String changePassword = '/profile/change-password';
  static const String somitiInfo = '/profile/somiti-info';
}
