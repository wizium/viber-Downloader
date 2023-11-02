import 'package:get/get.dart';

class VideoSelectionRadio extends GetxController {
  RxInt selectedVideo = 1.obs;
  changeValue({required int value}) {
    selectedVideo.value = value;
  }
}
