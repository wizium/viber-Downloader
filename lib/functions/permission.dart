import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> getStoragePermission() async {
  await checkAndAskForPermission("aos13 Storage Permission", Permission.videos)
      .then((value) async {
    await checkAndAskForPermission("Manage External Storage Permission",
            Permission.manageExternalStorage)
        .then((value) async {
      await checkAndAskForPermission(
              "Notification Permission", Permission.notification)
          .then((value) async {
        await checkAndAskForPermission(
            "Storage Permission", Permission.storage);
      });
    });
  });
}

Future<void> checkAndAskForPermission(
    String permissionName, Permission permissionType) async {
  PermissionStatus status = await permissionType.request();

  if (status.isGranted) {
    debugPrint("$permissionName Granted");
  } else {
    debugPrint("$permissionName Denied. Asking again...");

    status = await permissionType.request();

    if (status.isGranted) {
      debugPrint("$permissionName Granted after asking again");
    } else {
      debugPrint("$permissionName Denied even after asking again");
    }
  }
}
