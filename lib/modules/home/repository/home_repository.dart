import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../model/somiti_summary_model.dart';

abstract class IHomeRepository {
  Future<({Failure? failure, SomitiSummaryModel? summary})> getDashboardSummary();
}

class HomeRepository implements IHomeRepository {
  final ApiClient apiClient;

  HomeRepository({required this.apiClient});

  @override
  Future<({Failure? failure, SomitiSummaryModel? summary})> getDashboardSummary() async {
    try {
      // In production API environment:
      // final response = await apiClient.get(ApiConstants.dashboardSummary);
      // return (failure: null, summary: SomitiSummaryModel.fromJson(response.data['data']));

      await Future.delayed(const Duration(milliseconds: 600));
      return (
        failure: null,
        summary: const SomitiSummaryModel(
          memberName: 'মো: রফিকুল ইসলাম',
          memberId: 'SOM-2024-089',
          somitiName: 'প্রগতি বহুমুখী সমবায় সমিতি লিঃ',
          totalSavings: 45800.0,
          activeLoanBalance: 25000.0,
          totalSharesCount: 50,
          totalSharesValue: 5000.0,
          nextDueDate: '15 Nov 2026',
          nextDueAmount: 2500.0,
          unreadNoticesCount: 2,
        ),
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), summary: null);
    }
  }
}
