import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/app_version_model.dart';
import '../../../core/network/api_client.dart';

abstract class ISplashRepository {
  Future<({Failure? failure, AppVersionModel? versionData})> checkAppVersion();
}

class SplashRepository implements ISplashRepository {
  final ApiClient apiClient;

  SplashRepository({required this.apiClient});

  @override
  Future<({Failure? failure, AppVersionModel? versionData})> checkAppVersion() async {
    try {
      // Production fallback / demo simulation
      await Future.delayed(const Duration(milliseconds: 1200));
      return (
        failure: null,
        versionData: const AppVersionModel(
          minimumVersion: '1.0.0',
          latestVersion: '1.0.0',
          forceUpdate: false,
          updateUrl: 'https://play.google.com/store',
          releaseNotes: 'Performance improvements and bug fixes',
        ),
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), versionData: null);
    }
  }
}
