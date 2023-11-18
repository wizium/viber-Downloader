import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../main.dart';

getStoragePath() async {
  externalDir = (await getExternalStorageDirectory())!;
  directory = Directory(
    "${externalDir.parent.parent.parent.parent.path}/Viber/Downloads/",
  );
  if (!(await directory.exists())) {
    Directory(directory.path).createSync(recursive: true);
  }
}
