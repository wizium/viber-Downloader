import 'dart:convert';

import '/model/video_links.dart';
import '/model/video_screen.dart';

Future<VideoModel> parseVideoData(String rawResponse) async {
  final jsonData = jsonDecode(rawResponse);
  List links = jsonData["links"]["video"];
  List<VideoLinkModel> videoLinks = [];
  for (var link in links) {
    final videoLink = VideoLinkModel(
      link: link["url"],
      size: link["size"],
      quality: link["q_text"],
    );
    videoLinks.add(videoLink);
  }
  return VideoModel(
    title: jsonData["title"],
    platform: jsonData["extractor"],
    thumbnailLink: jsonData["thumbnail"].toString().split("\\")[0],
    downloadLink: videoLinks,
  );
}
