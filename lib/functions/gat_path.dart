import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../main.dart';

getStoragePath() async {
  String? storedFolderPath = preferences.getString('picked_folder_path');
  if (storedFolderPath != null) {
    directory = Directory(storedFolderPath);
  } else {
    externalDir = (await getExternalStorageDirectory())!;
    directory = Directory(
      "${externalDir.parent.parent.parent.parent.path}/Download",
    );
  }
  if (!(await directory.exists())) {
    Directory(directory.path).createSync(recursive: true);
  }
}
