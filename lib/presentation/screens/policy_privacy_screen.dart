import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyPrivacyScreen extends StatelessWidget {
  const PolicyPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 18,
        ),
        mini: true,
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            "https://viptouristQQQQQQQQQQQQQQQ.club/#/privacy-policy/", //////REMAKE IT AFTER
        // navigationDelegate: (NavigationRequest nav) async {
        //   return NavigationDecision.prevent;
        // },
      ),
    );
  }
}
