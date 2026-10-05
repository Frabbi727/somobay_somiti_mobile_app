import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/user_profile_model.dart';

abstract class IProfileRepository {
  Future<({Failure? failure, UserProfileModel? profile})> getProfile();
  Future<({Failure? failure, bool isSuccess})> changePassword(String currentPass, String newPass);
}

class ProfileRepository implements IProfileRepository {
  final ApiClient apiClient;

  ProfileRepository({required this.apiClient});

  @override
  Future<({Failure? failure, UserProfileModel? profile})> getProfile() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return (
        failure: null,
        profile: const UserProfileModel(
          id: 'USR-89',
          memberId: 'SOM-2024-089',
          name: 'মো: রফিকুল ইসলাম',
          phone: '01712345678',
          nid: '19922692019000123',
          email: 'rafiqul.islam@example.com',
          address: 'বাড়ি নং ১২, রোড নং ৫, ধানমন্ডি, ঢাকা',
          nomineeName: 'মোসা: খাদিজা বেগম',
          nomineeRelation: 'স্ত্রী (Wife)',
          joinedDate: '10 Jan 2024',
        ),
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), profile: null);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> changePassword(String currentPass, String newPass) async {
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }
}
