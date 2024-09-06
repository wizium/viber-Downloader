import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:viberloader/screens/media_player.dart';
import '../config.dart';
import '../screens/settings.dart';
import '../services/file_icon.dart';
import '../widget/loading.dart';
import '../services/download_service.dart';
import '/main.dart';
import '/widget/download_status_buttons.dart';
import 'donation.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  DownloadsState createState() => DownloadsState();
}

class DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => const PaymentsScreen(),
              );
            },
            icon: const Icon(CupertinoIcons.money_dollar),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const Settings());
            },
            icon: const Icon(CupertinoIcons.settings),
          ),
        ],
        centerTitle: false,
        title: const Text("Downloads"),
      ),
      body: StreamBuilder<List<Map>>(
        stream: DownloadService.downloadTaskStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: LoadingIndicator(),
            );
          }
          List<Map> downloadsListMaps = snapshot.data!;
          return downloadsListMaps.isEmpty
              ? const Center(
                  child: Text("No Downloads yet"),
                )
              : SingleChildScrollView(
                  child: ListView.builder(
                    itemCount: downloadsListMaps.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int i) {
                      Map map = downloadsListMaps[i];
                      String filename = map['filename'];
                      int progress = map['progress'];
                      DownloadTaskStatus status = map['status'];
                      String id = map['id'];
                      Map metadata =
                          box.getAt(downloadsListMaps.length - i - 1);
                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => WatchMedia(
                                mediaPath: "${directory.path}/$filename"),
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: gPadding),
                          child: Container(
                            height: 90,
                            padding: const EdgeInsets.all(gPadding),
                            margin: const EdgeInsets.symmetric(
                              vertical: gPadding * .5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(gPadding),
                              color: Theme.of(context).colorScheme.onPrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(.15),
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: isVideoFile(
                                            ".${filename.split(".").last}")
                                        ? BoxShape.rectangle
                                        : BoxShape.circle,
                                    borderRadius: isVideoFile(
                                            ".${filename.split(".").last}")
                                        ? BorderRadius.circular(gPadding)
                                        : null,
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(metadata["thumbNail"]),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: gPadding),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: gPadding),
                                      Flexible(
                                        child: Text(
                                          filename.length > 70
                                              ? filename.substring(0, 70)
                                              : filename,
                                        ),
                                      ),
                                      const SizedBox(height: gPadding),
                                      if (status != DownloadTaskStatus.complete)
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text('$progress%'),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: progress / 100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      Row(
                                        children: [
                                          Icon(
                                            getFileIcon(
                                                ".${filename.split(".").last}"),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(.7),
                                            size: 15,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            filename
                                                .split(".")
                                                .last
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(.7),
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          if (metadata["duration"] != "")
                                            Text(
                                              " | ${metadata["duration"]}",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(.7),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: gPadding),
                                    ],
                                  ),
                                ),
                                buttons(
                                  status,
                                  id,
                                  i,
                                  downloadsListMaps.length,
                                  context,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
