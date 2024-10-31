import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';


import 'package:webview_flutter/webview_flutter.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  if (WebView.platform == null) {
    WebView.platform = SurfaceAndroidWebView();
  }
  runApp(
    GetMaterialApp(
      title: "Apple Music",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}