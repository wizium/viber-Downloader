// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share_plus/share_plus.dart';
import '../main.dart';

void showCupertinoActions(
    BuildContext context,
    DownloadTaskStatus status,
    VoidCallback pauseDownload,
    VoidCallback resumeDownload,
    VoidCallback retryDownload,
    VoidCallback cancelAndRemoveDownload,
    String path) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        actions: [
          if (status == DownloadTaskStatus.running)
            CupertinoActionSheetAction(
              onPressed: () {
                pauseDownload();
                Navigator.of(context).pop(); // Close after action
              },
              child: const Text('Pause'),
            ),
          if (status == DownloadTaskStatus.paused)
            CupertinoActionSheetAction(
              onPressed: () {
                resumeDownload();
                Navigator.of(context).pop();
              },
              child: const Text('Resume'),
            ),
          if (status == DownloadTaskStatus.failed)
            CupertinoActionSheetAction(
              onPressed: () {
                retryDownload();
                Navigator.of(context).pop();
              },
              child: const Text('Retry'),
            ),
          CupertinoActionSheetAction(
            onPressed: () {
              cancelAndRemoveDownload();
              Navigator.of(context).pop(); // Close the sheet
            },
            isDestructiveAction: true,
            child: const Text('Remove'),
          ),
          if (status == DownloadTaskStatus.complete)
            CupertinoActionSheetAction(
              onPressed: () async {
                // Implement sharing functionality here
                Navigator.of(context).pop();
                await Share.shareXFiles(
                  [XFile(path)],
                  text:
                      "🚀 Video Downloader 🎥 Download your favorite videos instantly! 📲✨ Fast, easy, and in HD quality. Try it now: https://play.google.com/store/apps/details?id=com.wizium.viber.downloader 🚀📥",
                );
              },
              child: const Text('Share'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(); // Close the action sheet
          },
          child: const Text('Cancel'),
        ),
      );
    },
  );
}

Widget buttons(DownloadTaskStatus status, String taskid, int index, thumbId,
    path, BuildContext context) {
  void retryDownload() async => await FlutterDownloader.retry(taskId: taskid);

  void pauseDownload() async => await FlutterDownloader.pause(taskId: taskid);

  void resumeDownload() async => await FlutterDownloader.resume(taskId: taskid);

  void cancelAndRemoveDownload() async {
    await FlutterDownloader.remove(taskId: taskid, shouldDeleteContent: true);
    box.deleteAt(thumbId - index - 1);
  }

  // Build a button to open the Cupertino action sheet
  return IconButton(
    icon: const Icon(Icons.more_vert),
    onPressed: () {
      showCupertinoActions(context, status, pauseDownload, resumeDownload,
          retryDownload, cancelAndRemoveDownload, path);
    },
  );
}
