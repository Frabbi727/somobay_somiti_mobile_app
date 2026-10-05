import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Margin for bottom snackbars that keeps them above the system navigation bar
/// (Android draws the app edge-to-edge, so a plain 16 px margin lands under it).
EdgeInsets snackbarMargin() {
  final context = Get.context;
  final bottomInset = context == null
      ? 0.0
      : MediaQuery.viewPaddingOf(context).bottom;
  return EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset);
}
