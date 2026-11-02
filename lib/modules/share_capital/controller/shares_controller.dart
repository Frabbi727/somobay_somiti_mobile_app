import 'package:get/get.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../model/shares_overview_model.dart';
import '../repository/shares_repository.dart';

class SharesController extends GetxController {
  final ISharesRepository repository;

  SharesController({required this.repository});

  final overviewState = UIState<SharesOverviewModel>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    overviewState.value = UIState.loading();
    final result = await repository.getOverview();
    overviewState.value = result.overview != null ? UIState.success(result.overview!) : UIState.error(result.failure ?? const UnknownFailure());
  }
}
