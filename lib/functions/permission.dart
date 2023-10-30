import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

getStoragePermission() async {
  PermissionStatus storagePermission = await Permission.storage.request();
  PermissionStatus aos13StoragePermission = await Permission.videos.request();
  PermissionStatus notificationPermission =
      await Permission.notification.request();
  if (!aos13StoragePermission.isGranted) {
    debugPrint("aos13 Storage Permission Denied");
    Permission.videos.request();
  } else {
    debugPrint("Permission Granted");
  }
  if (!notificationPermission.isGranted) {
    debugPrint("Notification Permission Denied");
    Permission.notification.request();
  } else {
    debugPrint("Permission Granted");
  }

  //android 13 photos and videos permission needed
  if (!storagePermission.isGranted) {
    debugPrint("Storage Permission Denied");
    Permission.storage.request();
  } else {
    debugPrint("Permission Granted");
  }
}
