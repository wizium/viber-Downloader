import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viberloader/services/file_icon.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart'; // For audio playback
import '../widget/back_button.dart';

class WatchMedia extends StatefulWidget {
  final String mediaPath;
  const WatchMedia({super.key, required this.mediaPath});

  @override
  State<WatchMedia> createState() => _WatchMediaState();
}

class _WatchMediaState extends State<WatchMedia> {
  late VideoPlayerController videoPlayerController;
  late AudioPlayer audioPlayer; // For audio files
  bool isVideo = false;
  bool isInitialized = false;
  bool visible = true;
  IconData playState = Icons.pause_rounded;
  IconData audioState = Icons.volume_up_rounded;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Check the file extension to determine if it's a video or audio
    if (isVideoFile(".${widget.mediaPath.split(".").last}")) {
      isVideo = true;
      videoPlayerController = VideoPlayerController.file(
        File(widget.mediaPath),
        videoPlayerOptions: VideoPlayerOptions(
          allowBackgroundPlayback: true,
        ),
      )..initialize().then((value) {
          setState(() {
            isInitialized = true;
          });
          videoPlayerController.play();
        });
      videoPlayerController.addListener(() {
        playState = videoPlayerController.value.isPlaying
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded;
        setState(() {});
      });
    } else if (widget.mediaPath.endsWith('.mp3') ||
        widget.mediaPath.endsWith('.wav')) {
      isVideo = false;
      audioPlayer = AudioPlayer();
      audioPlayer.setFilePath(widget.mediaPath).then((value) {
        setState(() {
          isInitialized = true;
        });
        audioPlayer.play();
      });
      audioPlayer.playerStateStream.listen((state) {
        setState(() {
          playState =
              state.playing ? Icons.pause_rounded : Icons.play_arrow_rounded;
        });
      });
    }
  }

  @override
  void dispose() {
    if (isVideo) {
      videoPlayerController.dispose();
    } else {
      audioPlayer.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.bottom,
        SystemUiOverlay.top,
      ],
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(leading: const NewBackButton()),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: isInitialized
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  if (isVideo)
                    GestureDetector(
                      onTap: () {
                        visible = !visible;
                        setState(() {});
                      },
                      child: AspectRatio(
                        aspectRatio:
                            videoPlayerController.value.size.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      ),
                    ),
                  if (!isVideo)
                    Icon(
                      Icons.audiotrack,
                      size: 100,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: visible,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(right: 10.0),
                        height: 70,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              color: Theme.of(context).colorScheme.primary,
                              iconSize: 30,
                              onPressed: () {
                                if (isVideo) {
                                  videoPlayerController.value.isPlaying
                                      ? videoPlayerController.pause()
                                      : videoPlayerController.play();
                                } else {
                                  audioPlayer.playing
                                      ? audioPlayer.pause()
                                      : audioPlayer.play();
                                }
                              },
                              icon: Icon(playState),
                            ),
                            if (isVideo)
                              IconButton(
                                color: Theme.of(context).colorScheme.primary,
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
                                  setState(() {});
                                },
                                icon: Icon(audioState),
                              ),
                            Expanded(
                              child: Slider(
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                                value: (isVideo
                                        ? videoPlayerController
                                            .value.position.inSeconds
                                        : audioPlayer.position.inSeconds)
                                    .toDouble(),
                                min: 0,
                                max: (isVideo
                                        ? videoPlayerController
                                            .value.duration.inSeconds
                                        : audioPlayer.duration?.inSeconds ?? 0)
                                    .toDouble(),
                                onChanged: (sliderValue) {
                                  if (isVideo) {
                                    videoPlayerController.seekTo(Duration(
                                      seconds: sliderValue.toInt(),
                                    ));
                                  } else {
                                    audioPlayer.seek(Duration(
                                      seconds: sliderValue.toInt(),
                                    ));
                                  }
                                },
                              ),
                            ),
                            Text(
                              isVideo
                                  ? "${videoPlayerController.value.position.inMinutes}:${videoPlayerController.value.position.inSeconds % 60}/${videoPlayerController.value.duration.inMinutes}:${videoPlayerController.value.duration.inSeconds % 60}"
                                  : "${audioPlayer.position.inMinutes}:${audioPlayer.position.inSeconds % 60}/${audioPlayer.duration?.inMinutes ?? 0}:${audioPlayer.duration?.inSeconds ?? 0 % 60}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
