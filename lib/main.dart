import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:json_theme_plus/json_theme_plus.dart';
import 'package:path_provider/path_provider.dart';
import '/screens/splash.dart';
import 'stateControllers/state_controllers.dart';

late Directory externalDir;
late Directory directory;
late Box box;
ThemeData? lightTheme;
ThemeData? darkTheme;
AppStates appStates = Get.put(AppStates());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await FlutterDownloader.initialize();
  await Hive.openBox("Thumbs");
  final lThemeStr = await rootBundle.loadString('assets/light_theme.json');
  final lThemeJson = jsonDecode(lThemeStr);
  lightTheme = ThemeDecoder.decodeThemeData(lThemeJson)!;
  final dThemeStr = await rootBundle.loadString('assets/dark_theme.json');
  final dThemeJson = jsonDecode(dThemeStr);
  darkTheme = ThemeDecoder.decodeThemeData(dThemeJson)!;
  runApp(const BetterFeedback(child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

ReceivePort _port = ReceivePort();

class _AppState extends State<App> {
  @override
  void initState() {
    box = Hive.box("Thumbs");
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    appStates.themeStateUpdate();
    return GetMaterialApp(
      darkTheme: darkTheme!.copyWith(
        listTileTheme:
            ListTileThemeData(iconColor: darkTheme!.colorScheme.primary),
      ),
      theme: lightTheme!.copyWith(
        listTileTheme:
            ListTileThemeData(iconColor: lightTheme!.colorScheme.secondary),
      ),
      themeMode: appStates.dark.value ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
