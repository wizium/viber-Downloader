import "package:direct_link/direct_link.dart";
import "package:flutter/material.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:viberloader/screens/home.dart";

InAppWebViewController controller = InAppWebViewController("", webView);
late HeadlessInAppWebView webView;
late bool checkAlgoValue;

Future getVideoDetails(String userUrl) async {
  checkAlgoValue = false;
  webView = HeadlessInAppWebView(
    initialUrlRequest: URLRequest(url: Uri.parse(userUrl)),
    onLoadStop: (controller, url) async {
      checkAlgoValue = !checkAlgoValue;
      if (checkAlgoValue == false) {
        final extractedUrl = url.toString();
        debugPrint(extractedUrl);
        SiteModel? data = await DirectLink().check(
          downloadLink.text,
        );
        debugPrint(data!.title.toString());
        webView.dispose();
      }
    },
  );
  await webView.run();
}
