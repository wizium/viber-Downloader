import 'package:flutter/material.dart';
import 'package:viberloader/widget/loading.dart';
List<Widget> downloadUpperBody(
    context, height, videoModel, bool isPortrait, width) {
  return [
    Image.network(
      videoModel.thumbnailLink,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: child,
        );
      },
      fit: isPortrait ? BoxFit.cover : BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const LoadingIndicator();
      },
      height: height,
      width: width,
    ),
  ];
}
