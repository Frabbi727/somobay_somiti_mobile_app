import 'package:get/get.dart';
import '../../../core/utils/paged_list.dart';
import '../model/due_model.dart';
import '../repository/dues_repository.dart';

class DuesController extends GetxController {
  final IDuesRepository repository;

  DuesController({required this.repository});

  /// Backend status filter: open (unpaid) by default, as on the web portal.
  final status = 'open'.obs;

  /// Backend type filter; null = every type.
  final type = RxnString();

  late final PagedList<DueModel> dues = PagedList<DueModel>(
    (page) => repository.getDues(page: page, status: status.value, type: type.value),
  );

  @override
  void onInit() {
    super.onInit();
    dues.refresh();
  }

  void setStatus(String value) {
    status.value = value;
    dues.refresh();
  }

  void setType(String? value) {
    type.value = value;
    dues.refresh();
  }

  Future<void> refreshDues() => dues.refresh();
}
