import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(WebViewPage());
}

class WebViewPage extends StatefulWidget {

  @override
  _WebViewPageState createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State<WebViewPage> with WidgetsBindingObserver {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  String getAssetsPath(String path) {
    if (Platform.isAndroid) {
      return 'file:///android_asset/flutter_assets/' + path;
    } else {
      return 'file://Frameworks/App.framework/flutter_assets/' + path;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: getAssetsPath("assets/index.html"),
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: javascriptChannels(context),
      onWebViewCreated: (WebViewController controller) {
        _controller = controller;
      },
      onPageFinished: (url) {
        print("==================" + url);
      },
      navigationDelegate: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
    );
  }

  javascriptChannels(BuildContext context) {
    Set<JavascriptChannel> set = Set();
    set.add(_testJavascriptChannel());
    return set;
  }

  JavascriptChannel _testJavascriptChannel() {
    return JavascriptChannel(
        name: "testJavascriptChannel",
        onMessageReceived: (JavascriptMessage message) {
          showToast("Js call successful");
        });
  }
  showToast(String content) {
    Fluttertoast.showToast(
        msg: content,
        timeInSecForIos: 2,
        backgroundColor: Colors.black,
        gravity: ToastGravity.CENTER,
        fontSize: 10);
  }
}
