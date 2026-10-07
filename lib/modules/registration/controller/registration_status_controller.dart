import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/routes/home_route.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../../../core/services/storage_service.dart';
import '../../profile_settings/repository/profile_repository.dart';
import '../model/registration_model.dart';
import '../repository/registration_repository.dart';

/// "Where is my registration?" Asks whose session this is first: right after the final approval
/// the session has become a member's, and the member belongs on the dashboard.
class RegistrationStatusController extends GetxController {
  final IRegistrationRepository repository;
  final IProfileRepository? profileRepository;
  final StorageService? storageService;

  RegistrationStatusController({required this.repository, this.profileRepository, this.storageService});

  final state = UIState<RegistrationModel>.initial().obs;

  /// Same as the profile page's sign-out: tell the server (best effort), forget the tokens.
  Future<void> logout() async {
    await profileRepository?.logout();
    await storageService?.clearAuthData();
    Get.offAllNamed(AppRoutes.login);
  }

  /// The route to leave for, or null to stay on this screen.
  @override
  Future<String?> refresh() async {
    state.value = UIState.loading();

    final account = await repository.accountType();
    if (account.failure != null) {
      state.value = UIState.error(account.failure!);
      return null;
    }

    if (account.accountType != 'applicant') {
      return homeRouteFor(account.accountType);
    }

    final result = await repository.getRegistration();
    state.value = result.registration != null ? UIState.success(result.registration!) : UIState.error(result.failure ?? const UnknownFailure());
    return null;
  }
}
