import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../services/storage_service.dart';

/// A member who has not accepted the current rules gets 403 `terms_acceptance_required` on every
/// route. This sends them to the accept page, once even when several requests fail together.
/// The error is always passed on.
class TermsInterceptor extends Interceptor {
  final StorageService storageService;

  /// Opens the accept page; replaced in tests.
  final void Function() onRequired;

  static const code = 'terms_acceptance_required';

  static bool _navigating = false;

  TermsInterceptor({required this.storageService, void Function()? onRequired}) : onRequired = onRequired ?? _openAcceptPage;

  /// Allows the next 403 to open the accept page again (after accepting, or on logout).
  static void reset() => _navigating = false;

  static void _openAcceptPage() {
    if (Get.currentRoute == AppRoutes.acceptRules) return;
    Get.offAllNamed(AppRoutes.acceptRules);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final body = err.response?.data;
    final meta = body is Map ? body['meta'] : null;
    final isTermsGate = err.response?.statusCode == 403 && meta is Map && meta['code'] == code;

    if (isTermsGate && !_navigating && storageService.getAccountType() != 'applicant') {
      _navigating = true;
      onRequired();
    }
    handler.next(err);
  }
}
