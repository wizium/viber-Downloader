import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viberloader/widget/custom_buttons.dart';
import '../model/video_screen.dart';

class DownloadScreen extends StatefulWidget {
  final VideoModel videoModel;
  const DownloadScreen({super.key, required this.videoModel});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Video Found",
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: Get.height * 0.02,
          left: Get.width * 0.07,
          right: Get.width * 0.07,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.videoModel.thumbnailLink,
                errorBuilder: (context, error, stackTrace) {
                  return Expanded(
                    child: Container(
                      color: Colors.red,
                    ),
                  );
                },
                height: Get.height * .4,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Get.height * .01,
                // horizontal: Get.width * .05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.videoModel.platform,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  widget.videoModel.title.toUpperCase(),
                ),
              ),
            ),
            CustomButton(
              icon: Icons.file_download_rounded,
              childText: "Download Video",
              // color: Theme.of(context).colorScheme.inversePrimary,
              color: Colors.pink,
              onPressed: () {
                Get.bottomSheet(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: Get.height * 0.4,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: ListView.builder(
                          itemCount: widget.videoModel.downloadLink.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(value: false, onChanged: (value) {}),
                                Text(
                                  widget.videoModel.downloadLink[index].quality,
                                ),
                                Text(
                                  widget.videoModel.downloadLink[index].size,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            CustomButton(
              icon: Icons.music_note_rounded,
              childText: "Download Mp3",
              color: Colors.indigo,
              onPressed: () {},
            ),
            CustomButton(
              icon: Icons.stream,
              childText: "Stream adFree",
              color: Colors.deepPurple,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
