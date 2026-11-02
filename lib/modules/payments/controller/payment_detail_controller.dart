import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../model/payment_detail_model.dart';
import '../repository/payments_repository.dart';

/// One payment; its id arrives as the route argument (only ever the member's own payment ids,
/// and the backend answers 404 for anything else).
class PaymentDetailController extends GetxController {
  final IPaymentsRepository repository;

  PaymentDetailController({required this.repository});

  final paymentState = UIState<PaymentDetailModel>.initial().obs;
  final openingReceipt = false.obs;
  late final int paymentId;

  @override
  void onInit() {
    super.onInit();
    paymentId = Get.arguments as int;
    fetch();
  }

  Future<void> fetch() async {
    paymentState.value = UIState.loading();
    final result = await repository.getPayment(paymentId);
    paymentState.value = result.payment != null ? UIState.success(result.payment!) : UIState.error(result.failure ?? const UnknownFailure());
  }

  /// Opens the signed receipt link in the phone's browser / PDF viewer.
  Future<String?> openReceipt() async {
    openingReceipt.value = true;
    final result = await repository.receiptUrl(paymentId);
    openingReceipt.value = false;

    if (result.url == null) {
      return result.failure?.message ?? 'payment_receipt_open_failed';
    }

    final opened = await launchUrl(Uri.parse(result.url!), mode: LaunchMode.externalApplication);
    return opened ? null : 'payment_receipt_open_failed';
  }
}
