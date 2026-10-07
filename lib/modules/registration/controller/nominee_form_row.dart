import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/utils/bangla_number_util.dart';
import '../model/registration_model.dart';

/// One nominee card on the form; its text fields and chosen relation.
class NomineeFormRow {
  final nameController = TextEditingController();
  final nidController = TextEditingController();
  final mobileController = TextEditingController();
  final shareController = TextEditingController();
  final relationId = RxnInt();

  NomineeFormRow();

  factory NomineeFormRow.fromModel(RegistrationNomineeModel nominee) {
    final row = NomineeFormRow();
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
    };
  }

  void dispose() {
    nameController.dispose();
    nidController.dispose();
    mobileController.dispose();
    shareController.dispose();
  }
}
