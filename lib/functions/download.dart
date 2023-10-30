import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

startDownload(url) async {
  Directory? directory = await getDownloadsDirectory();
  if (!await directory!.exists()) {
    await directory.create();
  }
  await FlutterDownloader.enqueue(
    url: url,
    savedDir: directory.path,
    fileName: "myFile.png",
  );
}
