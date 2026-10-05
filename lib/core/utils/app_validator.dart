import 'package:get/get.dart';
import '../constants/app_constants.dart';
import 'bangla_number_util.dart';

class AppValidator {
  AppValidator._();

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_phone_required'.tr;
    }
    final englishPhone = BanglaNumberUtil.toEnglish(value.trim());
    final regExp = RegExp(AppConstants.bdPhoneRegex);
    if (!regExp.hasMatch(englishPhone)) {
      return 'validation_phone_invalid'.tr;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_password_required'.tr;
    }
    if (value.trim().length < 6) {
      return 'validation_password_min_length'.tr;
    }
    return null;
  }

  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null 
          ? '$fieldName ${'validation_is_required'.tr}' 
          : 'validation_required'.tr;
    }
    return null;
  }

  static String? validateAmount(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_amount_required'.tr;
    }
    final englishValue = BanglaNumberUtil.toEnglish(value.trim());
    final amount = double.tryParse(englishValue);
    if (amount == null || amount <= 0) {
      return 'validation_amount_invalid'.tr;
    }
    if (min != null && amount < min) {
      return '${'validation_amount_min'.tr} $min';
    }
    if (max != null && amount > max) {
      return '${'validation_amount_max'.tr} $max';
    }
    return null;
  }

  static String? validateNID(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation_nid_required'.tr;
    }
    final englishNid = BanglaNumberUtil.toEnglish(value.trim());
    final regExp = RegExp(AppConstants.nidRegex);
    if (!regExp.hasMatch(englishNid)) {
      return 'validation_nid_invalid'.tr;
    }
    return null;
  }
}
