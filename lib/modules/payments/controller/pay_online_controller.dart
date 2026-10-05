import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../repository/payments_repository.dart';

/// The portal's Pay Online form. One idempotency key per form: a retry after a timeout reuses it,
/// so the backend returns the same payment instead of creating a second one. The amount is sent as
/// typed (Bangla digits allowed); the backend parses it exactly.
class PayOnlineController extends GetxController {
  final IPaymentsRepository repository;

  PayOnlineController({required this.repository});

  /// Matches the backend limit (somiti.max_proof_kb = 2048).
  static const maxProofBytes = 2048 * 1024;

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final trxController = TextEditingController();

  final method = 'bkash'.obs;
  final receivedOn = _today().obs;
  final proofPath = RxnString();
  final proofName = RxnString();
  final sending = false.obs;
  final failure = Rxn<Failure>();
  String? lastMessage;

  String _idempotencyKey = const Uuid().v4();

  static String _today() => DateTime.now().toIso8601String().substring(0, 10);

  void setProof({required String path, required String name}) {
    proofPath.value = path;
    proofName.value = name;
  }

  /// Field error from the last 422, e.g. errorFor('trx_id').
  String? errorFor(String field) => failure.value?.validationErrors?[field]?.first;

  /// Sends the form; true when the backend accepted it (the payment is pending approval).
  Future<bool> send() async {
    if (sending.value || proofPath.value == null) return false;

    sending.value = true;
    failure.value = null;
    final result = await repository.submit(
      method: method.value,
      amount: amountController.text.trim(),
      trxId: BanglaNumberUtil.toEnglish(trxController.text.trim()).toUpperCase(),
      receivedOn: receivedOn.value,
      proofPath: proofPath.value!,
      idempotencyKey: _idempotencyKey,
    );
    sending.value = false;

    if (result.failure != null) {
      failure.value = result.failure;
      return false;
    }

    lastMessage = result.message;
    _idempotencyKey = const Uuid().v4(); // the next payment is a new form
    return true;
  }

  @override
  void onClose() {
    amountController.dispose();
    trxController.dispose();
    super.onClose();
  }
}
