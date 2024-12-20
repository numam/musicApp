import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../views/NoConnectionView.dart';
import '../views/home_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      // Mengupdate status koneksi berdasarkan hasil perubahan konektivitas
      _updateConnectionStatus(connectivityResult as ConnectivityResult);
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Tidak ada koneksi
      Get.offAll(() => const NoConnectionView());
    } else {
      // Koneksi tersedia (WiFi atau Mobile Data)
      if (Get.currentRoute == '/NoConnectionView') {
        Get.offAll(() => const HomeView());
      }
    }
  }
}
