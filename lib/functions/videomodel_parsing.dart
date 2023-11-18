import 'dart:convert';
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
    final quality = removeCharsFromString(
      link["q_text"].toString(),
      [
        "[",
        "]",
        "-",
        "link",
      ],
    );
    if (link["url"].toString().split(".").last != "m3u8") {
      final videoLink = VideoLinkModel(
        link: link["url"],
        size: link["size"],
        quality: quality,
      );
      if (quality.split(" ").first == "MP4" ||
          quality.split(" ").first == "Watermarked") {
        videoLinks.add(videoLink);
      } else {
        audioLinks.add(videoLink);
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
