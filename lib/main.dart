import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(WebViewPage("http://192.168.1.232:93/#/login"));
}

class WebViewPage extends StatefulWidget {
  String htmlUrl;

  WebViewPage(this.htmlUrl);

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

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.htmlUrl,
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
    set.add(_saveUserInfoToApp());
    set.add(_turnAppHome());
    return set;
  }

  JavascriptChannel _saveUserInfoToApp() {
    return JavascriptChannel(
        name: "saveUserInfoToApp",
        onMessageReceived: (JavascriptMessage message) {
          showToast("saveUserInfoToApp");
        });
  }

  JavascriptChannel _turnAppHome() {
    return JavascriptChannel(
        name: "turnAppHome",
        onMessageReceived: (JavascriptMessage message) {
          showToast("turnAppHome");
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
