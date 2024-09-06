import 'package:direct_link/direct_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../services/download_service.dart';
import '../services/file_icon.dart';
import '../main.dart';
import '../widget/back_button.dart';
import '../widget/loading.dart';

class DownloadScreen extends StatefulWidget {
  final SiteModel siteModel;
  const DownloadScreen({super.key, required this.siteModel});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Video Found"),
        leading: const NewBackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(gPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.siteModel.title!),
            const SizedBox(height: gPadding * 2),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.network(
                  widget.siteModel.thumbnail!,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(parentBorderRadius),
                      child: child,
                    );
                  },
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const LoadingIndicator();
                  },
                  height: 300,
                  width: Get.width,
                ),
                if (widget.siteModel.duration != null)
                  Positioned(
                    left: gPadding / 3,
                    bottom: gPadding / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(childBorderRadius),
                      ),
                      margin: const EdgeInsets.all(gPadding),
                      padding: const EdgeInsets.all(gPadding),
                      child: Text(
                        "Durations ${widget.siteModel.duration!}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: gPadding * 2),
            ListView.builder(
              itemCount: widget.siteModel.links!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: gPadding),
                    child: ListTile(
                      leading: Icon(getFileIcon(
                        ".${widget.siteModel.links![index].type!}",
                      )),
                      trailing: Radio(
                        groupValue: appStates.selectedVideo.value,
                        onChanged: (value) {
                          appStates.selectedVideo.value = value!;
                        },
                        value: index,
                      ),
                      onTap: () {
                        appStates.selectedVideo.value = index;
                      },
                      title: Text(widget.siteModel.links![index].quality),
                    ),
                  );
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(gPadding),
        child: SizedBox(
          height: buttonHeight,
          width: Get.width,
          child: FilledButton(
            onPressed: () {
              DownloadService.startDownload(
                widget.siteModel.links![appStates.selectedVideo.value].link,
                widget.siteModel.thumbnail!,
                widget.siteModel.duration,
              );
            },
            child: const Text("Download"),
          ),
        ),
      ),
    );
  }
}
