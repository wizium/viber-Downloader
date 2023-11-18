import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/download.dart';

downloadUpperBody(context, height, videoModel, bool isPortrait, width) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          videoModel.thumbnailLink,
          // fit: isPortrait ? BoxFit.cover : BoxFit.contain,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.red,
            );
          },
          height: height,
          width: width,
        ),
      ),
      isPortrait
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: Get.height * .01,
                // horizontal: Get.width * .05,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  platform!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            )
          : const SizedBox()
    ],
  );
}
