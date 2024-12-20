import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArtistDetailScreen extends StatefulWidget {
  @override
  _ArtistDetailScreenState createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  late WebViewController _webViewController; // Declare the WebView controller
  bool isLoading = true; // Track if the WebView is still loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscribe'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _webViewController.canGoBack()) {
                _webViewController.goBack();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await _webViewController.canGoForward()) {
                _webViewController.goForward();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: 'https://music.apple.com/us/subscribe',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController controller) {
              _webViewController = controller;
            },
            onPageStarted: (String url) {
              setState(() {
                isLoading = true; // Start loading
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false; // Finish loading
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                )
              : Container(),
        ],
      ),
    );
  }
}
