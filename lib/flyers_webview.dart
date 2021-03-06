import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:scelteperte/partials/bottom_banner.dart';
import 'package:webview_flutter/webview_flutter.dart';


class VolantinoWebViewArgs{
  String url;
  VolantinoWebViewArgs({this.url});
}

class VolantiniWebView extends StatefulWidget {
  @override
  _VolantiniWebViewState createState() => _VolantiniWebViewState();
}

/// This Widget is the main application widget.
class _VolantiniWebViewState extends State<VolantiniWebView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final VolantinoWebViewArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
      title: Text("Volantini Conad"), backgroundColor: Colors.green),
      bottomNavigationBar: BottomBanner(),
      body: WebView(
        initialUrl: args.url,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      )
    );
  }
}
