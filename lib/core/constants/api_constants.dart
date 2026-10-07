/// Member API endpoints (backend routes/api.php; see docs/MEMBER_API_SPECIFICATION.md).
/// Only endpoints the backend has are listed here.
class ApiConstants {
  ApiConstants._();

  // Auth
  static const String login = '/api/v1/auth/login';
  static const String sendCode = '/api/v1/auth/send-code';
  static const String refreshToken = '/api/v1/auth/refresh-token';
  static const String logout = '/api/v1/auth/logout';
  static const String me = '/api/v1/auth/me';

  // Society
  static const String somitiInfo = '/api/v1/config/somiti-info';

  static const String nomineeRelations = '/api/v1/config/nominee-relations';

  // Self-registration (applicant token)
  static const String registration = '/api/v1/registration';
  static const String registrationPhoto = '/api/v1/registration/photo';
  static const String registrationSubmit = '/api/v1/registration/submit';

  // Member
  static const String dashboardSummary = '/api/v1/dashboard/summary';
  static const String dues = '/api/v1/dues';
  static const String payments = '/api/v1/payments';
  static String paymentDetail(int id) => '/api/v1/payments/$id';
  static String paymentReceipt(int id) => '/api/v1/payments/$id/receipt';
  static const String statement = '/api/v1/statement';
  static const String statementPdfLink = '/api/v1/statement/pdf-link';
  static const String dividends = '/api/v1/dividends';
  static const String sharesOverview = '/api/v1/shares/overview';
  static const String profile = '/api/v1/profile';
  static const String changePassword = '/api/v1/profile/change-password';
  static const String notifications = '/api/v1/notifications';

  /// Requests that must never trigger a token refresh when they fail with 401.
  static const List<String> noRefresh = [login, sendCode, refreshToken];
}
