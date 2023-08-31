import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  _PrivacyState createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
      ),
      body: WebView(
        initialUrl: 'https://www.getyourguide.com/privacy_policy',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest nav) {
          if (!nav.url.contains('privacy')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
