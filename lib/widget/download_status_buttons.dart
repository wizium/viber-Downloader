import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:viberloader/main.dart';

Widget buttons(DownloadTaskStatus status, String taskid, int index, thumbId) {
  void retryDownload() {
    FlutterDownloader.retry(taskId: taskid);
  }

  void pauseDownload() {
    FlutterDownloader.pause(taskId: taskid);
  }

  void resumeDownload() {
    FlutterDownloader.resume(taskId: taskid);
  }

  void cancelDownload() {
    FlutterDownloader.cancel(taskId: taskid);
    FlutterDownloader.remove(taskId: taskid, shouldDeleteContent: true);
    box.deleteAt(thumbId-index-1);
  }

  switch (status) {
    case DownloadTaskStatus.canceled:
      return Row(
        children: [
          GestureDetector(
            onTap: retryDownload,
            child: const Icon(
              Icons.restart_alt_outlined,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          GestureDetector(
            onTap: cancelDownload,
            child: const Icon(
              Icons.delete_rounded,
              size: 20,
            ),
          ),
        ],
      );
    case DownloadTaskStatus.failed:
      return Row(
        children: [
          GestureDetector(
            onTap: retryDownload,
            child: const Icon(
              Icons.restart_alt_rounded,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          GestureDetector(
            onTap: cancelDownload,
            child: const Icon(
              Icons.close_rounded,
              size: 20,
            ),
          ),
        ],
      );
    case DownloadTaskStatus.paused:
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: resumeDownload,
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          GestureDetector(
            onTap: cancelDownload,
            child: const Icon(
              Icons.close_rounded,
              size: 20,
            ),
          ),
        ],
      );
    case DownloadTaskStatus.running:
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: pauseDownload,
            child: const Icon(
              Icons.pause_rounded,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 7,
          ),
          GestureDetector(
            onTap: cancelDownload,
            child: const Icon(
              Icons.close_rounded,
              size: 20,
            ),
          ),
        ],
      );
    case DownloadTaskStatus.complete:
      return GestureDetector(
        onTap: cancelDownload,
        child: const Icon(
          Icons.delete,
          size: 20,
        ),
      );
    default:
      return const SizedBox();
  }
}
