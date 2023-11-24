import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:viberloader/main.dart';

Widget buttons(DownloadTaskStatus status, String taskid, int index, thumbId) {
  void retryDownload() async => await FlutterDownloader.retry(taskId: taskid);

  void pauseDownload() async => await FlutterDownloader.pause(taskId: taskid);

  void resumeDownload() async => await FlutterDownloader.resume(taskId: taskid);

  void cancelAndRemoveDownload() async {
    await FlutterDownloader.remove(taskId: taskid, shouldDeleteContent: true);
    box.deleteAt(thumbId - index - 1);
  }

  IconButton buildIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onTap,
    );
  }

  switch (status) {
    case DownloadTaskStatus.canceled:
      return Row(
        children: [
          buildIconButton(Icons.restart_alt_outlined, retryDownload),
          buildIconButton(Icons.delete_rounded, cancelAndRemoveDownload),
        ],
      );
    case DownloadTaskStatus.failed:
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildIconButton(Icons.restart_alt_rounded, retryDownload),
          buildIconButton(Icons.close_rounded, cancelAndRemoveDownload),
        ],
      );
    case DownloadTaskStatus.paused:
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildIconButton(Icons.play_arrow_rounded, resumeDownload),
          buildIconButton(Icons.close_rounded, cancelAndRemoveDownload),
        ],
      );
    case DownloadTaskStatus.running:
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildIconButton(Icons.pause_rounded, pauseDownload),
          buildIconButton(Icons.close_rounded, cancelAndRemoveDownload),
        ],
      );
    case DownloadTaskStatus.complete:
      return buildIconButton(Icons.delete, cancelAndRemoveDownload);
    default:
      return const SizedBox();
  }
}
