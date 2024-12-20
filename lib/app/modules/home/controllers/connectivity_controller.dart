import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivity.onConnectivityChanged.listen((status) {
      isOnline.value = (status != ConnectivityResult.none);
      if (isOnline.value) {
        Get.snackbar("Online", "You are connected to the internet",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      } else {
        Get.snackbar("Offline", "No internet connection",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    });
  }

  void _checkInitialConnection() async {
    var status = await _connectivity.checkConnectivity();
    isOnline.value = (status != ConnectivityResult.none);
  }
}
