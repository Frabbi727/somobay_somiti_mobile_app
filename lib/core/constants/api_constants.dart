class ApiConstants {
  ApiConstants._();

  // Auth Endpoints
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String refreshToken = '/api/v1/auth/refresh-token';
  static const String logout = '/api/v1/auth/logout';

  // Config & Startup
  static const String versionCheck = '/api/v1/config/version-check';
  static const String somitiInfo = '/api/v1/config/somiti-info';

  // Dashboard & Summary
  static const String dashboardSummary = '/api/v1/dashboard/summary';

  // Savings & DPS
  static const String savingsAccounts = '/api/v1/savings/accounts';
  static const String savingsDeposit = '/api/v1/savings/deposit';

  // Loans
  static const String loanAccounts = '/api/v1/loans/accounts';
  static const String loanRepay = '/api/v1/loans/repay';
  static const String loanCalculate = '/api/v1/loans/calculate';

  // Shares
  static const String shareOverview = '/api/v1/shares/overview';

  // Members
  static const String members = '/api/v1/members';

  // Transactions (Passbook)
  static const String transactions = '/api/v1/transactions';

  // Notifications
  static const String notifications = '/api/v1/notifications';

  // Profile
  static const String profile = '/api/v1/profile';
  static const String changePassword = '/api/v1/profile/change-password';
}
