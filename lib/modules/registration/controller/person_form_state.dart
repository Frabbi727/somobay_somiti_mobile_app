import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/models/enum_value_model.dart';
import '../model/registration_model.dart';
import '../repository/geo_repository.dart';
import 'address_form_state.dart';

/// The paper form's personal block, the same for the member and for each nominee:
/// gender, passport, present and permanent address and the "same as present" tick.
class PersonFormState {
  static final _passportPattern = RegExp(r'^[A-Z0-9]{6,20}$');

  final AddressFormState present;
  final AddressFormState permanent;
  final gender = RxnString();
  final passportController = TextEditingController();
  final permanentSameAsPresent = false.obs;

  PersonFormState({required IGeoRepository geo}) : present = AddressFormState(geo: geo), permanent = AddressFormState(geo: geo);

  /// Ticking copies the present address now; later edits to it are copied again when sent.
  void setSameAsPresent(bool same) {
    permanentSameAsPresent.value = same;
    if (same) {
      permanent.copyFrom(present);
    } else if (!permanent.unionsLoaded.value && permanent.upazilaId.value != null) {
      // A load that was running when the copy happened was dropped; ask again so the union list is not left empty.
      permanent.reloadUnions();
    }
  }

  /// What the server stores: uppercase, without spaces.
  String? get passport {
    final value = passportController.text.replaceAll(RegExp(r'\s'), '').toUpperCase();
    return value.isEmpty ? null : value;
  }

  bool get passportValid => passport == null || _passportPattern.hasMatch(passport!);

  Future<void> load({EnumValueModel? savedGender, String? savedPassport, RegistrationAddressModel? savedPresent, RegistrationAddressModel? savedPermanent}) async {
    gender.value = savedGender?.value;
    passportController.text = savedPassport ?? '';
    permanentSameAsPresent.value = savedPresent != null && savedPresent.sameAs(savedPermanent);
    await Future.wait([present.fromModel(savedPresent), permanent.fromModel(savedPermanent)]);
  }

  Map<String, dynamic> toJson() {
    if (permanentSameAsPresent.value) permanent.copyFrom(present);
    return {'gender': gender.value, 'passport_no': passport, ...present.toJson('present'), ...permanent.toJson('permanent'), 'permanent_same_as_present': permanentSameAsPresent.value};
  }

  void dispose() {
    passportController.dispose();
    present.dispose();
    permanent.dispose();
  }
}
