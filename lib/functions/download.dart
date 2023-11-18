import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:media_scanner/media_scanner.dart';
import '/main.dart';

startDownload(url, String name, int isAudio, thumbnailUrl) async {
  name = name.replaceAll(RegExp(r'[^a-zA-Z0-9. ]'), '').trim();
  try {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.path,
      fileName: isAudio == 0 ? "$name.mp4" : "$name.mp3",
      showNotification: true,
      openFileFromNotification: false,
    ).then((value) async {
      await MediaScanner.loadMedia(path: "${directory.path}/$name.mp4");
      await box.add(thumbnailUrl);
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}
