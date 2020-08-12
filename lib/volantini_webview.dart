import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VolantiniWebView extends StatefulWidget {

  String url;
  VolantiniWebView({Key key, this.url}) : super(key: key);

  @override
  _VolantiniWebViewState createState() => _VolantiniWebViewState();
}

/// This Widget is the main application widget.
class _VolantiniWebViewState extends State<VolantiniWebView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  String url;

  @override
  void initState() {
    super.initState();
    url = widget.url;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Volantini Conad"), backgroundColor: Colors.green),
      body: WebView(
        initialUrl: 'https://gustourconad.it/volantino-conad#book-461' /*url*/,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        onWebViewCreated: (WebViewController webViewController) {
          log('ciao');
          _controller.complete(webViewController);
        },
      )
    );
  }
}
