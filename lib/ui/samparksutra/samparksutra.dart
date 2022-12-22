import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';
class SamparkSutraWebView extends StatefulWidget {
  @override
  SamparkSutraWebViewState createState() => SamparkSutraWebViewState();
}

class SamparkSutraWebViewState extends State<SamparkSutraWebView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'http://www.rajswasthya.nic.in/ContactSutra.htm',
    );
  }
}