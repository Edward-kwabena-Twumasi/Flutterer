import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main(List<String> args) {
  runApp(WebViewpg(pageurl: 'flutter.dev',));
}

class WebViewpg extends StatefulWidget {
  WebViewpg({required this.pageurl});
 final String pageurl;
  @override
  WebViewpgState createState() => WebViewpgState();
}

class WebViewpgState extends State<WebViewpg> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl:widget.pageurl,
       javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
