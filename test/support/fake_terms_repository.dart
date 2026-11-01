import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/terms/model/terms_model.dart';
import 'package:somobay_somiti_mobile_app/modules/terms/repository/terms_repository.dart';

import 'fixtures.dart';

TermsModel termsVersion(int version) => TermsModel.fromJson({...(fixture('terms_current')['data'] as Map<String, dynamic>), 'version': version});

/// The rules from the fixture (version 3 unless [version] is changed); records what was accepted.
class FakeTermsRepository implements ITermsRepository {
  int version = 3;
  Failure? currentFailure;
  final List<Failure?> acceptAnswers = [];
  final List<({int version, String key})> accepted = [];
  int currentCalls = 0;

  @override
  Future<TermsResult> current() async {
    currentCalls++;
    return currentFailure != null ? (failure: currentFailure, terms: null) : (failure: null, terms: termsVersion(version));
  }

  @override
  Future<({Failure? failure})> accept(int version, String idempotencyKey) async {
    accepted.add((version: version, key: idempotencyKey));
    return (failure: acceptAnswers.isEmpty ? null : acceptAnswers.removeAt(0));
  }
}
