import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import 'splash.dart';

class VideoView extends StatefulWidget {
  final bool isNetwork;
  final String video;
  const VideoView({super.key, required this.video, required this.isNetwork});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController videoPlayerController;
  bool visible = true;
  IconData playState = Icons.pause_rounded;
  IconData audioState = Icons.volume_up_rounded;

  @override
  void initState() {

    super.initState();
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (widget.isNetwork) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.video),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ),
      )
        ..initialize().then((value) => {
              setState(() {}),
            })
        ..addListener(() {
          playState = videoPlayerController.value.isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded;
          setState(() {});
        });
    } else {
      videoPlayerController = VideoPlayerController.file(
        File(widget.video),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ),
      )
        ..initialize().then((value) => {
              setState(() {}),
            })
        ..addListener(() {
          playState = videoPlayerController.value.isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded;
          setState(() {});
        });
    }

    videoPlayerController.play();
  }

  @override
  void dispose() {
    if (isLoaded) {
      adService.showInterstitialAd(() {
        adService.interstitialAdLoad();
      });
    } else {
      adService.interstitialAdLoad();
    }
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top,
      ],
    );
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: visible
          ? AppBar(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
              ),
              leadingWidth: Get.width * .07,
              leading: IconButton(
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                ),
              ),
              backgroundColor: Colors.black.withOpacity(.3),
              title: SizedBox(
                height: Get.height * .1,
                child: Marquee(
                  text: widget.video.split('/').last,
                  blankSpace: Get.width,
                ),
              ),
            )
          : null,
      backgroundColor: Colors.black,
      body: Center(
        child: videoPlayerController.value.isInitialized
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      visible ? visible = false : visible = true;
                    },
                    child: AspectRatio(
                      aspectRatio: videoPlayerController.value.size.aspectRatio,
                      child: VideoPlayer(
                        videoPlayerController,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: visible,
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                videoPlayerController.value.isPlaying
                                    ? videoPlayerController.pause()
                                    : videoPlayerController.play();
                              },
                              icon: Icon(playState),
                            ),
                            IconButton(
                              color: Colors.white,
                              iconSize: 30,
                              onPressed: () {
                                videoPlayerController.setVolume(
                                    audioState == Icons.volume_up_rounded
                                        ? 0
                                        : 1);
                                audioState =
                                    audioState == Icons.volume_up_rounded
                                        ? Icons.volume_off_rounded
                                        : Icons.volume_up_rounded;
                              },
                              icon: Icon(audioState),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: videoPlayerController
                                    .value.position.inSeconds
                                    .toDouble(),
                                min: 0,
                                max: videoPlayerController
                                    .value.duration.inSeconds
                                    .toDouble(),
                                onChanged: (sliderValue) {
                                  videoPlayerController.seekTo(
                                    Duration(
                                      seconds: sliderValue.toInt(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              "${videoPlayerController.value.position.inMinutes}:${videoPlayerController.value.position.inSeconds % 60}/${videoPlayerController.value.duration.inMinutes}:${videoPlayerController.value.duration.inSeconds % 60}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Container(),
      ),
    );
  }
}
