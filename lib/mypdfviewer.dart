import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyPdfViewer extends StatelessWidget {

  MyPdfViewer(String fileUrl)
  {
    this.myPdfUrl = fileUrl;
  }
  late WebViewController _controller;
  var myPdfUrl;

  @override
  Widget build(BuildContext context) {
    print(myPdfUrl);
    return Container(
      child: Center(
        child: WebView(
        initialUrl: myPdfUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController)
        {
            _controller = webViewController;
          },
        ),
      )
    );
  }
}
