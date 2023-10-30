import "package:flutter/material.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/functions/videoModel_parsing.dart';
import 'package:viberloader/screens/download.dart';

InAppWebViewController controller = InAppWebViewController("", webView);
late HeadlessInAppWebView webView;
late bool checkAlgoValue;

getData(String userUrl) async {
  final uriHost = Uri.parse(userUrl).host;
  debugPrint(uriHost);
  if (uriHost == "fb.watch" || uriHost == "www.facebook.com") {
    String? extractedUrl;
    checkAlgoValue = false;
    webView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(userUrl)),
      onLoadStop: (controller, url) async {
        checkAlgoValue = !checkAlgoValue;
        if (checkAlgoValue == false) {
          extractedUrl = url.toString();
          debugPrint(extractedUrl);
          getVideoData(extractedUrl: extractedUrl!);
          webView.dispose();
        }
      },
    );
    await webView.run();
  } else if (uriHost == "m.youtube.com" ||
      uriHost == "youtu.be" ||
      uriHost == "youtube.com") {
    Get.snackbar(
      "Sorry",
      "Youtube video cant be downloaded Because of legal restrictions 😞",
    );
  } else {
    getVideoData(extractedUrl: userUrl);
  }
}

void getVideoData(
    {required String extractedUrl, String k_page = "Home"}) async {
  final headers = {
    'Accept': '*/*',
    'Accept-Language': 'en-GB,en-US;q=0.9,en;q=0.8',
    'Connection': 'keep-alive',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'Origin': 'https://www.y2mate.com',
    'Referer': 'https://www.y2mate.com/en/instagram-downloader/CynnzUWM1Y2',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'User-Agent':
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36',
    'X-Requested-With': 'XMLHttpRequest',
    'sec-ch-ua':
        '"Chromium";v="118", "Google Chrome";v="118", "Not=A?Brand";v="99"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"macOS"',
    'Accept-Encoding': 'gzip',
  };

  final data = {
    'k_query': extractedUrl,
    'k_page': k_page,
    'hl': 'en',
    'q_auto': '1',
  };

  final url = Uri.parse('https://www.y2mate.com/mates/en/analyzeV2/ajax');

  final res = await http.post(url, headers: headers, body: data);
  final status = res.statusCode;
  if (status != 200) throw Exception('http.post error: statusCode= $status');
  if (jsonDecode(res.body)["mess"] == "") {
    final responseData = await parseVideoData(res.body);
    Get.to(DownloadScreen(
      videoModel: responseData,
    ));
  } else {
    try {
      final linkLength =
          jsonDecode(res.body)["mess"].toString().split("\"")[1].split("/");
      final newPage = linkLength[linkLength.length - 2].split("-")[0];
      debugPrint(newPage);
      getVideoData(extractedUrl: extractedUrl, k_page: newPage);
    } catch (e) {
      Get.snackbar("Error", "Link is invalid");
    }
  }
}
