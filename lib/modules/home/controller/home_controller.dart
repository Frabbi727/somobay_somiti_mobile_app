import 'package:get/get.dart';
import '../../../core/models/ui_state.dart';
import '../model/dashboard_summary_model.dart';
import '../repository/home_repository.dart';

class HomeController extends GetxController {
  final IHomeRepository repository;

  HomeController({required this.repository});

  final summaryState = UIState<DashboardSummaryModel>.initial().obs;
  final isBalanceHidden = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSummary();
  }

  void toggleBalanceVisibility() {
    isBalanceHidden.value = !isBalanceHidden.value;
  }

  Future<void> fetchSummary() async {
    summaryState.value = UIState.loading();
    final result = await repository.getDashboardSummary();
    if (result.failure != null) {
      summaryState.value = UIState.error(result.failure!);
    } else if (result.summary != null) {
      summaryState.value = UIState.success(result.summary!);
    } else {
      summaryState.value = UIState.empty();
    }
  }
}
