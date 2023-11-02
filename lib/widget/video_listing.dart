import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/model/video_screen.dart';
import '/stateControllers/state_controllers.dart';

VideoSelectionRadio videoSelectionRadio = Get.put(VideoSelectionRadio());
videoListing(BuildContext context, VideoModel videoList, int isAudio) {
  Get.bottomSheet(
    Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: isAudio == 0 ? Get.height * .4 : Get.height * .3,
      padding: EdgeInsets.symmetric(
        horizontal: Get.width * .05,
        vertical: Get.height * .02,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: videoList.downloadLink[isAudio].length,
              shrinkWrap: false,
              itemBuilder: (context, index) {
                return Obx(() {
                  return ListTile(
                    splashColor: Colors.transparent,
                    leading: Image.asset(
                      isAudio == 0 ? "assets/facebook.png" : "assets/mp3.png",
                      scale: 7,
                    ),
                    trailing: Radio.adaptive(
                      groupValue: videoSelectionRadio.selectedVideo.value,
                      onChanged: (value) {
                        videoSelectionRadio.changeValue(value: value!);
                      },
                      value: index,
                    ),
                    onTap: () {
                      videoSelectionRadio.changeValue(value: index);
                    },
                    title: Text(
                      videoList.downloadLink[isAudio][index].quality,
                    ),
                    subtitle: Text(
                      videoList.downloadLink[isAudio][index].size,
                    ),
                  );
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Get.height * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: Get.height * .07,
                  // width: Get.width * .3,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * .07,
                  // width: Get.width * .3,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_rounded,
                      ),
                      label: const Text(
                        "Download",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
  );
}
