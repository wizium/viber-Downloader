import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:viberloader/screens/stream_free.dart';
import 'package:viberloader/widget/loading.dart';
import '/main.dart';
import '/functions/load_download_tasks.dart';
import '/widget/download_status_buttons.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  DownloadsState createState() => DownloadsState();
}

class DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(
          Icons.delete_forever_rounded,
        ),
        onPressed: () async {
          await FlutterDownloader.cancelAll();
          await FlutterDownloader.loadTasks().then(
            (value) async {
              for (var i in value!) {
                FlutterDownloader.remove(
                    taskId: i.taskId, shouldDeleteContent: true);
                await box.deleteAll(box.keys);
              }
            },
          );
        },
        label: const Text("Clear All"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return StreamBuilder<List<Map>>(
            stream: downloadTaskStream(),
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
                  : ListView.builder(
                      itemCount: downloadsListMaps.length,
                      itemBuilder: (BuildContext context, int i) {
                        Map map = downloadsListMaps[i];
                        String filename = map['filename'];
                        int progress = map['progress'];
                        DownloadTaskStatus status = map['status'];
                        String id = map['id'];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: CachedNetworkImage(
                                imageUrl:
                                    box.getAt(downloadsListMaps.length - i - 1),
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: orientation == Orientation.portrait
                                        ? Get.width * .25
                                        : Get.width * .2,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.signal_cellular_nodata_rounded,
                                ),
                              ),
                              onTap: status == DownloadTaskStatus.complete
                                  ? (() {
                                      Get.to(
                                        VideoView(
                                          video: "${directory.path}/$filename",
                                          isNetwork: false,
                                        ),
                                      );
                                    })
                                  : null,
                              isThreeLine: false,
                              title: Text(filename),
                              subtitle: status == DownloadTaskStatus.complete
                                  ? const SizedBox()
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text('$progress%'),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: LinearProgressIndicator(
                                                value: progress / 100,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                              trailing: buttons(
                                status,
                                id,
                                i,
                                downloadsListMaps.length,
                              ),
                            ),
                            const Divider(
                              indent: 15,
                              endIndent: 15,
                            )
                          ],
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }
}
