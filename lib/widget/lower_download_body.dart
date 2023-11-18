import 'package:flutter/material.dart';
import 'package:viberloader/screens/download.dart';
import '/widget/video_listing.dart';
import '/widget/custom_buttons.dart';

lowerDownloadBody(context, height, width,videoModel) {
  return [
    CustomButton(
      height: height,
      width: width,
      icon: platform == "TIKTOK"
          ? Icons.layers_rounded
          : Icons.play_arrow_rounded,
      childText: platform == "TIKTOK" ? "Watermarked" : "Video Download",
      color: Colors.pink,
      onPressed: () {
        videoListing(
          false,
          platform == "TIKTOK" ? true : false,
          context,
          videoModel,
          0,
        );
      },
    ),
    CustomButton(
      height: height,
      width: width,
      icon: platform == "TIKTOK"
          ? Icons.layers_clear_rounded
          : Icons.audiotrack_rounded,
      childText: platform == "TIKTOK" ? "No Watermark" : "Audio Download",
      color: Colors.indigo,
      onPressed: () {
        videoListing(
          false,
          platform == "TIKTOK" ? true : false,
          context,
          videoModel,
          1,
        );
      },
    ),
    CustomButton(
      height: height,
      width: width,
      icon: Icons.stream,
      childText: "Stream adFree",
      color: Colors.deepPurple,
      onPressed: () {
        videoListing(
          true,
          platform == "TIKTOK" ? true : false,
          context,
          videoModel,
          0,
        );
      },
    ),
  ];
}
