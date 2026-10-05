import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/app_version_model.dart';
import '../../../core/widgets/app_dialogs.dart';

class ForceUpdatePage extends StatelessWidget {
  const ForceUpdatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppVersionModel versionData = Get.arguments as AppVersionModel? ??
        const AppVersionModel(
          minimumVersion: '1.0.0',
          latestVersion: '1.0.0',
          forceUpdate: true,
          updateUrl: 'https://play.google.com/store',
        );

    return Scaffold(
      body: Center(
        child: AppForceUpdateDialog(
          updateUrl: versionData.updateUrl,
          releaseNotes: versionData.releaseNotes,
        ),
      ),
    );
  }
}
