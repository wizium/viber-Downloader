import 'dart:convert';
import 'package:get/get.dart';
import '/model/video_links.dart';
import '/model/video_screen.dart';

String removeCharsFromString(String input, List<String> charsToRemove) {
  String pattern = charsToRemove.map((char) => RegExp.escape(char)).join('|');
  RegExp regExp = RegExp(pattern);
  return input.replaceAllMapped(regExp, (match) => '');
}

Future<VideoModel> parseVideoData(String rawResponse) async {
  final jsonData = jsonDecode(rawResponse);
  List links = jsonData["links"]["video"];
  List<VideoLinkModel> videoLinks = [];
  List<VideoLinkModel> audioLinks = [];
  for (var link in links) {
    List<String> quality = removeCharsFromString(
      link["q_text"].toString(),
      [
        "[",
        "]",
        "-",
        "link",
      ],
    ).split(" ");

    if (quality.last.isNumericOnly) {
      quality.removeLast();
    }
    final newQuality = quality.join(" ");
    if (link["url"].toString().split(".").last != "m3u8") {
      final videoLink = VideoLinkModel(
        link: link["url"],
        size: link["size"],
        quality: newQuality,
      );
      if (newQuality.split(" ").first == "MP4" ||
          newQuality.split(" ").first == "Watermarked") {
        if (videoLinks.isNotEmpty) {
          if (newQuality == videoLinks.last.quality) {
            videoLinks.add(videoLink);
            videoLinks.removeLast();
          } else {
            videoLinks.add(videoLink);
          }
        } else {
          videoLinks.add(videoLink);
        }
      } else if (newQuality.split(" ").first == "JPG") {
      } else {
        if (audioLinks.isNotEmpty) {
          if (newQuality == audioLinks.last.quality) {
            audioLinks.add(videoLink);
            audioLinks.removeLast();
          } else {
            audioLinks.add(videoLink);
          }
        } else {
          audioLinks.add(videoLink);
        }
      }
    }
  }
  return VideoModel(
    title: jsonData["title"],
    platform: jsonData["extractor"],
    thumbnailLink: jsonData["thumbnail"].toString().split("\\")[0],
    downloadLink: [videoLinks, audioLinks],
  );
}
