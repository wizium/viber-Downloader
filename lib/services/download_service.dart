import 'dart:io';
import 'dart:math' as math;
import 'package:direct_link/direct_link.dart';
import "package:flutter/material.dart";
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import '../screens/download.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';

class DownloadService {
  static Future<void> getData(String mediaUrl) async {
    late String uriHost;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      uriHost = Uri.parse(mediaUrl).host;
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(
        msg: "Invalid URL. Please try again with a valid URL.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    debugPrint(uriHost);

    if (uriHost == "m.youtube.com" ||
        uriHost == "youtu.be" ||
        uriHost == "youtube.com") {
      Get.back();
      Fluttertoast.showToast(
        msg:
            "Due to legal restrictions, we can't download videos from YouTube. Please use a different link.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      return;
    } else {
      await DirectLink().check(mediaUrl).then((value) {
        Get.back();

        if (value!.links!.isNotEmpty) {
          Get.to(() => DownloadScreen(siteModel: value));
          return;
        } else {
          Fluttertoast.showToast(
            msg: "No download links found.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
          return;
        }
      }).catchError((error) {
        Get.back();
        Fluttertoast.showToast(
          msg: "An error occurred: ${error.toString()}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
      });
      return;
    }
  }

  static getStoragePath() async {
    String? storedFolderPath = box.get('picked_folder_path');
    if (storedFolderPath != null) {
      directory = Directory(storedFolderPath);
    } else {
      externalDir = (await getExternalStorageDirectory())!;
      directory = Directory(
        "${externalDir.parent.parent.parent.parent.path}/Download",
      );
      box.put("picked_folder_path", directory);
    }
    if (!(await directory.exists())) {
      Directory(directory.path).createSync(recursive: true);
    }
  }

  static Stream<List<Map>> downloadTaskStream() async* {
    while (true) {
      List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
      List<Map> downloadsListMaps = [];
      for (var task in getTasks!.reversed) {
        Map map = {};
        map['status'] = task.status;
        map['progress'] = task.progress;
        map['id'] = task.taskId;
        map['filename'] = task.filename;
        map['savedDirectory'] = task.savedDir;
        downloadsListMaps.add(map);
      }
      yield downloadsListMaps;
    }
  }

  static Future<void> checkAndRequestPermissions(BuildContext context) async {
    await _checkAndRequestNotificationPermission(context);
    await _checkAndRequestStoragePermission(context);
  }

  static Future<void> _checkAndRequestNotificationPermission(
      BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isDenied || status.isRestricted) {
      final result = await Permission.notification.request();

      if (result.isDenied) {
        _showPermissionDialog(
          context,
          title: 'Notification Permission',
          content:
              'This app needs Notification permission to alert you of important updates.',
          onSettingsPressed: _openAppSettings,
        );
      }
    }
  }

  static Future<void> _checkAndRequestStoragePermission(
      BuildContext context) async {
    final status = await Permission.storage.status;

    if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.storage.request();

      if (result.isDenied) {
        _showPermissionDialog(
          context,
          title: 'Storage Permission',
          content:
              'This app needs Storage permission to save and access files on your device.',
          onSettingsPressed: _openAppSettings,
        );
      }
    }
  }

  static void _showPermissionDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onSettingsPressed,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: onSettingsPressed,
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  static void _openAppSettings() async {
    await openAppSettings();
  }

  static startDownload(url, thumbnailUrl, duration) async {
    try {
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory.path,
        saveInPublicStorage: true,
        showNotification: true,
        openFileFromNotification: false,
      ).then((value) async {
        final response = await get(Uri.parse(thumbnailUrl));
        String path =
            "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png";
        final file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        await box.add({
          "thumbNail": path,
          "duration": duration ?? "",
        });
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static String getFileSize(String filepath, int decimals) {
    var file = File(filepath);
    int bytes = file.lengthSync();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
