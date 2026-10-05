import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../model/statement_model.dart';
import '../repository/transaction_repository.dart';

/// The passbook: the member statement for a date range (the backend's default is the fiscal
/// year so far; the range it used comes back in the response).
class TransactionController extends GetxController {
  final ITransactionRepository repository;

  TransactionController({required this.repository});

  final statementState = UIState<StatementModel>.initial().obs;
  final openingPdf = false.obs;
  String? _from;
  String? _until;

  @override
  void onInit() {
    super.onInit();
    fetchStatement();
  }

  Future<void> fetchStatement() async {
    statementState.value = UIState.loading();
    final result = await repository.getStatement(from: _from, until: _until);
    statementState.value = result.statement != null ? UIState.success(result.statement!) : UIState.error(result.failure ?? const UnknownFailure());
  }

  Future<void> setRange(String from, String until) async {
    _from = from;
    _until = until;
    await fetchStatement();
  }

  /// Opens the signed PDF link (valid 15 minutes) outside the app; returns an error key or message.
  Future<String?> openPdf() async {
    final current = statementState.value.data;
    openingPdf.value = true;
    final result = await repository.statementPdfUrl(from: current?.from ?? _from, until: current?.until ?? _until);
    openingPdf.value = false;

    if (result.url == null) return result.failure?.message ?? 'statement_pdf_failed';

    final opened = await launchUrl(Uri.parse(result.url!), mode: LaunchMode.externalApplication);
    return opened ? null : 'statement_pdf_failed';
  }
}
