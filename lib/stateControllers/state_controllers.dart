import 'package:get/get.dart';
class AppStates extends GetxController {
  RxInt selectedVideo = 1.obs;
  RxBool isLoading = false.obs;
  toggleLoading(){
    isLoading.value = !isLoading.value;
  }
  changeValue({required int value}) {
    selectedVideo.value = value;
  }
}
