class AppConstants {
  AppConstants._();

  static const String appName = 'Somobay Somiti';
  static const String defaultLocale = 'bn';
  static const String defaultCountry = 'BD';
  static const int defaultPageSize = 15;
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;

  // Validation RegEx
  static const String bdPhoneRegex = r'^(?:\+88|88)?(01[3-9]\d{8})$';
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String nidRegex = r'^(?:\d{10}|\d{13}|\d{17})$';
}
