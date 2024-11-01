import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'app/modules/home/controllers/playlist_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  if (WebView.platform == null) {
    WebView.platform = SurfaceAndroidWebView();
  }

  Get.lazyPut(() => PlaylistController());

  runApp(
    GetMaterialApp(
      title: "Apple Music",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
