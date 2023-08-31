import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String url;
  const PaymentScreen({Key? key, required this.url}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.url,
        navigationDelegate: (NavigationRequest nav) async {
          if (nav.url.contains("success") || nav.url.contains("return")) {
            Navigator.pop(context, true);
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
