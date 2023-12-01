// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import "package:flutter/material.dart";
import 'package:get/get.dart';
// import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viberloader/widget/error_bottom_sheet.dart';
import 'package:viberloader/widget/video_listing.dart';
import '/functions/videoModel_parsing.dart';
import 'package:viberloader/screens/download.dart';

getData(String userUrl, BuildContext context) async {
  String uriHost;
  try {
    uriHost = Uri.parse(userUrl).host;
  } catch (e) {
    errorSheet(
      context,
      errorMessage:
          "Invalid URL Please try again.\nAfter that, try again with a valid URL.",
    );
    appStates.toggleLoading();
    return;
  }
  debugPrint(uriHost);
  if (uriHost == "fb.watch" || uriHost == "www.facebook.com") {
    errorSheet(context,
        errorMessage:
            "Facebook videos downloading is currently not supported. support coming soon.");
    appStates.toggleLoading();
  } else if (uriHost == "m.youtube.com" ||
      uriHost == "youtu.be" ||
      uriHost == "youtube.com") {
    errorSheet(
      context,
      errorMessage:
          "Due to legal restrictions, we can't download videos from YouTube. Please use a different link.",
    );
    appStates.toggleLoading();
  } else {
    getVideoData(extractedUrl: userUrl, context: context);
  }
}

void getVideoData(
    {required String extractedUrl,
    String kpage = "Instagram",
    required BuildContext context}) async {
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
    'k_page': kpage,
    'hl': 'en',
    'q_auto': '1',
  };

  final url = Uri.parse('https://www.y2mate.com/mates/en/analyzeV2/ajax');
  try {
    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');
    if (jsonDecode(res.body)["mess"] == "") {
      final responseData = await parseVideoData(res.body);
      Get.snackbar(
        "Video Found",
        "😇",
      );
      Get.to(
        DownloadScreen(
          videoModel: responseData,
        ),
      );
    } else {
      getVideoData(
        extractedUrl: extractedUrl,
        kpage: "Instagram",
        context: context,
      );
      appStates.toggleLoading();
    }
  } catch (e) {
    debugPrint(e.toString());
    errorSheet(
      context,
      errorMessage:
          "There is some issue while fetching data.\nMaybe check your internet Connection or Link and try again.",
    );
  }
  appStates.toggleLoading();
}
