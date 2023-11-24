import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viberloader/screens/splash.dart';
import 'package:viberloader/widget/lower_download_body.dart';
import '/widget/download_upper_body.dart';
import '/model/video_screen.dart';

String? platform;
late List costumeButtons;

class DownloadScreen extends StatefulWidget {
  final VideoModel videoModel;
  const DownloadScreen({super.key, required this.videoModel});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  void initState() {
    if (isLoaded) {
      adService.showInterstitialAd(() {
        adService.interstitialAdLoad();
      });
    } else {
      adService.interstitialAdLoad();
    }
    setState(() {
      platform = widget.videoModel.platform.split("-")[0].toUpperCase();
    });

    super.initState();
  }

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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
            child: orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: downloadUpperBody(
                          context,
                          Get.height * .4,
                          widget.videoModel,
                          true,
                          Get.width * .8,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Text(
                          widget.videoModel.platform.toUpperCase(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(widget.videoModel.title),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: lowerDownloadBody(
                          context,
                          Get.height * .08,
                          Get.width * .9,
                          widget.videoModel,
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: downloadUpperBody(
                              context,
                              Get.height * .57,
                              widget.videoModel,
                              false,
                              Get.width * .4,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: lowerDownloadBody(
                              context,
                              Get.height * .17,
                              Get.width * .4,
                              widget.videoModel,
                            ),
                          )
                        ],
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(widget.videoModel.title),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
