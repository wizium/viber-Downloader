import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:viberloader/main.dart';
import 'package:viberloader/services/purchase.dart';

IsPro isPro = Get.put(IsPro());

class IsPro extends GetxController {
  RxBool isPro = false.obs;
  init() {
    isPro.value = preferences.getBool("isPro") ?? false;
    if (isPro.isFalse) {
      initStore(() {});
    }
  }
}

subscriptionCheck(Timestamp endDate) async {
  if (endDate.toDate().isAfter(DateTime.now())) {
    preferences.setBool("isPro", true);
  } else {
    preferences.setBool("isPro", false);
  }
  isPro.init();
}
