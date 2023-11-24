// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:viberloader/functions/gat_path.dart';

Future<void> getStoragePermission(BuildContext context) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

  // Extract major version number
  int androidVersion = int.parse(androidInfo.version.release.split('.')[0]);
  if (androidVersion >= 13) {
    await _checkAndAskForPermission(
      context,
      "Notification Permission",
      Permission.notification,
      "This app requires access to notifications to download videos for you. Please grant the necessary permissions.",
    );
  }
  if (androidVersion >= 11) {
    await _checkAndAskForPermission(
      context,
      "Manage External Storage Permission",
      Permission.manageExternalStorage,
      "This app requires access to manage external storage to download videos for you. Please grant the necessary permissions.",
    );
  }
  await _checkAndAskForPermission(
    context,
    "Storage Permission",
    Permission.storage,
    "This app requires access to storage to download videos for you. Please grant the necessary permissions.",
  );
}

Future<void> _checkAndAskForPermission(
  BuildContext context,
  String permissionName,
  Permission permissionType,
  String explanation,
) async {
  PermissionStatus status = await permissionType.request();

  if (status.isGranted) {
    debugPrint("$permissionName Granted");
  } else {
    debugPrint("$permissionName Denied. Asking again...");

    status = await permissionType.request();

    if (status.isGranted) {
      debugPrint("$permissionName Granted after asking again");
    } else {
      debugPrint(
          "$permissionName Denied even after asking again. Opening app settings...");

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(explanation),
              const SizedBox(height: 10),
              Text(
                "To enable the permission, go to Settings > Viber Video Downloader > Permissions and enable $permissionName.",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      await openAppSettings();
    }
  }
  getStoragePath();
}
