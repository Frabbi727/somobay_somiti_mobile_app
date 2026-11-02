import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/utils/bangla_number_util.dart';
import '../model/registration_model.dart';
import '../repository/geo_repository.dart';
import 'person_form_state.dart';

/// One nominee card on the form; its text fields and chosen relation.
class NomineeFormRow {
  final nameController = TextEditingController();
  final nidController = TextEditingController();
  final mobileController = TextEditingController();
  final shareController = TextEditingController();
  final relationId = RxnInt();
  final PersonFormState person;

  NomineeFormRow({required IGeoRepository geo}) : person = PersonFormState(geo: geo);

  /// Completes when the address pickers have their lists (the saved chain, or the divisions).
  Future<void> geoReady = Future.value();

  /// Loads the first list of the address pickers (a new, empty row).
  void loadGeo() => geoReady = person.load();

  factory NomineeFormRow.fromModel(RegistrationNomineeModel nominee, {required IGeoRepository geo}) {
    final row = NomineeFormRow(geo: geo);
    row.geoReady = row.person.load(savedGender: nominee.gender, savedPassport: nominee.passportNo, savedPresent: nominee.presentAddress, savedPermanent: nominee.permanentAddress);
    row.nameController.text = nominee.name;
    row.nidController.text = nominee.nid ?? '';
    row.mobileController.text = nominee.mobile ?? '';
    row.shareController.text = nominee.sharePercent;
    row.relationId.value = nominee.relationId;
    return row;
  }

  Map<String, dynamic> toJson() {
    String? text(TextEditingController controller) {
      final value = BanglaNumberUtil.toEnglish(controller.text.trim());
      return value.isEmpty ? null : value;
    }

    return {
      'name': nameController.text.trim(),
      'relation_id': relationId.value,
      'nid': text(nidController),
      'mobile': text(mobileController),
      'share_percent': text(shareController),
      ...person.toJson(),
    };
  }

  void dispose() {
    nameController.dispose();
    nidController.dispose();
    mobileController.dispose();
    shareController.dispose();
    person.dispose();
  }
}
