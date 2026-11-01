import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/interceptors/terms_interceptor.dart';
import '../../../core/services/storage_service.dart';
import '../../profile_settings/repository/profile_repository.dart';
import '../model/terms_model.dart';
import '../repository/terms_repository.dart';

/// A member who has not accepted the current rules reads them here and accepts before using the app.
class AcceptRulesController extends GetxController {
  final ITermsRepository repository;
  final IProfileRepository profileRepository;
  final StorageService storageService;

  /// Opens a route replacing the whole stack; replaced in tests.
  final void Function(String route) navigate;

  AcceptRulesController({
    required this.repository,
    required this.profileRepository,
    required this.storageService,
    void Function(String route)? navigate,
  }) : navigate = navigate ?? ((route) => Get.offAllNamed(route));

  final terms = Rxn<TermsModel>();
  final agreed = false.obs;
  final loading = true.obs;
  final accepting = false.obs;
  final failure = Rxn<Failure>();

  /// One key per page; renewed only when the rules change underneath (the server ties a key to one version).
  String _idempotencyKey = const Uuid().v4();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    failure.value = null;
    final result = await repository.current();
    loading.value = false;

    if (result.terms == null) {
      failure.value = result.failure ?? const UnknownFailure();
      return;
    }

    if (terms.value != null && terms.value!.version != result.terms!.version) {
      agreed.value = false;
      _idempotencyKey = const Uuid().v4();
    }
    terms.value = result.terms;
  }

  /// True when accepted; the member then goes to the home screen.
  Future<bool> accept() async {
    final current = terms.value;
    if (accepting.value || !agreed.value || current == null) return false;

    accepting.value = true;
    failure.value = null;
    final result = await repository.accept(current.version, _idempotencyKey);
    accepting.value = false;

    if (result.failure != null) {
      failure.value = result.failure;
      // Newer rules may have been published meanwhile: show them and ask again.
      if (result.failure!.statusCode == 422 || result.failure!.statusCode == 409) {
        final message = result.failure;
        await load();
        failure.value = message;
      }
      return false;
    }

    TermsInterceptor.reset();
    navigate(AppRoutes.dashboard);
    return true;
  }

  Future<void> logout() async {
    await profileRepository.logout();
    await storageService.clearAuthData();
    TermsInterceptor.reset();
    navigate(AppRoutes.login);
  }
}

/// Read-only view of the current rules (from the profile).
class RulesController extends GetxController {
  final ITermsRepository repository;

  RulesController({required this.repository});

  final terms = Rxn<TermsModel>();
  final loading = true.obs;
  final failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    failure.value = null;
    final result = await repository.current();
    loading.value = false;
    terms.value = result.terms;
    failure.value = result.terms == null ? (result.failure ?? const UnknownFailure()) : null;
  }
}
