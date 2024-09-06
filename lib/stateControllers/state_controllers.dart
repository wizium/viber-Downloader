import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viberloader/main.dart';

class AppStates extends GetxController {
  RxBool dark = true.obs;
  RxInt selectedVideo = 0.obs;
  RxBool isLoading = false.obs;
  startLoading() {
    isLoading.value = true;
  }

  stopLoading() {
    isLoading.value = false;
  }

  changeValue({required int value}) {
    selectedVideo.value = value;
  }

  themeStateSave(bool theme) async {
    dark.value = theme;
    Get.changeThemeMode(dark.value ? ThemeMode.dark : ThemeMode.light);
    await box.put("isDark", dark.value);
  }

  themeStateUpdate() {
    dark.value = box.get("isDark", defaultValue: true);
  }
}
