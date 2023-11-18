import 'package:flutter_downloader/flutter_downloader.dart';

Stream<List<Map>> downloadTaskStream() async* {
  while (true) {
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Adjust the delay as needed

    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    List<Map> downloadsListMaps = [];

    for (var task in getTasks!.reversed) {
      Map map = {};
      map['status'] = task.status;
      map['progress'] = task.progress;
      map['id'] = task.taskId;
      map['filename'] = task.filename;
      map['savedDirectory'] = task.savedDir;
      downloadsListMaps.add(map);
    }

    yield downloadsListMaps;
  }
}
