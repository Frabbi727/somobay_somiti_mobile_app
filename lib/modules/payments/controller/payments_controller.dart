import 'package:get/get.dart';
import '../../../core/utils/paged_list.dart';
import '../model/payment_summary_model.dart';
import '../repository/payments_repository.dart';

class PaymentsController extends GetxController {
  final IPaymentsRepository repository;

  PaymentsController({required this.repository});

  /// Backend status filter; null = every payment.
  final status = RxnString();

  late final PagedList<PaymentSummaryModel> payments = PagedList<PaymentSummaryModel>(
    (page) => repository.getPayments(page: page, status: status.value),
  );

  @override
  void onInit() {
    super.onInit();
    payments.refresh();
  }

  void setStatus(String? value) {
    status.value = value;
    payments.refresh();
  }

  Future<void> refreshPayments() => payments.refresh();
}
