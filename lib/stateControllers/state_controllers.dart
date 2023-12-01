import 'package:get/get.dart';
class AppStates extends GetxController {
  RxInt selectedVideo = 0.obs;
  RxBool isLoading = false.obs;
  startLoading(){
    isLoading.value = true;
  }
  stopLoading(){
    isLoading.value = false;
  }
  changeValue({required int value}) {
    selectedVideo.value = value;
  }
}
