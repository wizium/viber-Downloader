import 'package:viberloader/model/video_links.dart';

class VideoModel {
  String title;
  String platform;
  String thumbnailLink;
  List<VideoLinkModel> downloadLink;
  VideoModel({
    required this.title,
    required this.platform,
    required this.thumbnailLink,
    required this.downloadLink,
  });
}
