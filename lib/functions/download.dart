import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:media_scanner/media_scanner.dart';
import '/main.dart';

startDownload(url, String name, int isAudio, thumbnailUrl) async {
  
  if (await File(
          "${directory.path}/${isAudio == 0 ? "$name.mp4" : "$name.mp3"}")
      .exists()) {
    name = name +
        (Random().nextInt(10000).toString() +
                Random().nextInt(10000).toString())
            .substring(0, 4);
  }
  try {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.path,
      saveInPublicStorage: true,
      fileName: isAudio == 0 ? "$name.mp4" : "$name.mp3",
      showNotification: true,
      openFileFromNotification: false,
    ).then((value) async {
      Future.delayed(const Duration(seconds: 2), () async {
        await MediaScanner.loadMedia(path: "${directory.path}/$name.mp4");
      });
      Get.snackbar("Success", "Downloaded Started 🥳");
      await box.add(thumbnailUrl);
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}
