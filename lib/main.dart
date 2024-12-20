import 'package:apple_music/app/modules/home/notification_service.dart';
import 'package:apple_music/app/modules/home/controllers/playlist_controller.dart';
import 'package:apple_music/app/modules/home/controllers/connectivity_controller.dart'; // Tambahkan
import 'package:apple_music/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Untuk penyimpanan lokal
import 'package:webview_flutter/webview_flutter.dart';

import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase dan GetStorage
  await Firebase.initializeApp();
  await GetStorage.init();

  // Inisialisasi NotificationService
  await NotificationService.instance.initialize();

  // Konfigurasi WebView
  if (WebView.platform == null) {
    WebView.platform = SurfaceAndroidWebView();
  }

  // Register PlaylistController dan ConnectivityController
  Get.lazyPut(() => PlaylistController());
  Get.lazyPut(() => ConnectivityController()); // Tambahkan controller koneksi

  runApp(
    GetMaterialApp(
      title: "Apple Music",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
  DependencyInjection.init(); 
}
