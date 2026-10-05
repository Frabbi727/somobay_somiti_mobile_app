import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'log_service.dart';

class NetworkConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  Future<NetworkConnectivityService> init() async {
    final initialResults = await _connectivity.checkConnectivity();
    _updateConnectionStatus(initialResults);

    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final hasConnection = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (isConnected.value != hasConnection) {
      isConnected.value = hasConnection;
      LogService.i('Network Status Changed: isConnected = $hasConnection', tag: 'CONNECTIVITY');
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
