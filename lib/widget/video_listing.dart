import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viberloader/functions/download.dart';
import 'package:viberloader/screens/stream_free.dart';
import '/screens/splash.dart';
import '/model/video_screen.dart';
import '/stateControllers/state_controllers.dart';

AppStates appStates = Get.put(AppStates());
videoListing(
  bool stream,
  bool isTiktok,
  BuildContext context,
  VideoModel videoList,
  int isAudio,
) {
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
            child: videoList.downloadLink[isAudio].isEmpty
                ? Center(
                    child: Text(
                      "Sorry no media found.",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )
                : ListView.builder(
                    itemCount: videoList.downloadLink[isAudio].length,
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      return Obx(() {
                        return ListTile(
                          splashColor: Colors.transparent,
                          leading: isTiktok
                              ? Image.asset(
                                  "assets/facebook.png",
                                  scale: 5,
                                )
                              : Image.asset(
                                  isAudio == 0
                                      ? "assets/facebook.png"
                                      : "assets/mp3.png",
                                  scale: 5,
                                ),
                          trailing: Radio.adaptive(
                            groupValue: appStates.selectedVideo.value,
                            onChanged: (value) {
                              appStates.changeValue(value: value!);
                            },
                            value: index,
                          ),
                          onTap: () {
                            appStates.changeValue(value: index);
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
          videoList.downloadLink[isAudio].isEmpty
              ? const SizedBox()
              : Padding(
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
                            onPressed: () async {
                              String name;
                              final url = videoList
                                  .downloadLink[isAudio]
                                      [appStates.selectedVideo.value]
                                  .link;
                              Get.back();
                              if (stream) {
                                Get.to(
                                  VideoView(
                                    video: url,
                                    isNetwork: true,
                                  ),
                                );
                              } else {
                                try {
                                  name = videoList.title.substring(0, 30);
                                } catch (e) {
                                  name = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                }
                                if (isLoaded) {
                                  adService.showInterstitialAd(() {
                                    adService.interstitialAdLoad();
                                  });
                                } else {
                                  adService.interstitialAdLoad();
                                }
                                startDownload(
                                  url,
                                  name,
                                  isTiktok ? 0 : isAudio,
                                  videoList.thumbnailLink,
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.download_rounded,
                            ),
                            label: Text(
                              stream ? "Stream Online" : "Download",
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
