import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '/screens/splash.dart';
import 'services/ad_service.dart';

bool isPro = true;
bool isDark = false;
late SharedPreferences preferences;
late Directory externalDir;
late Directory directory;
late Box box;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  Hive.init(
    (await getApplicationDocumentsDirectory()).path,
  );
  await Hive.openBox("Thumbs");
  await UnityAds.init(
    testMode: false,
    gameId: AdServices.appId,
    onComplete: () => debugPrint("Unity gameId is Initialized"),
    onFailed: (error, errorMessage) => debugPrint(errorMessage),
  );
  runApp(
    const BetterFeedback(
      child: App(),
    ),
  );
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
    isDark = preferences.getBool("isDark") ?? true;
    box = Hive.box("Thumbs");
    setState(() {});
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
    return GetMaterialApp(
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.red,
          background: Colors.black,
          // seedColor: Colors.purple,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.red,
          // seedColor: Colors.purple,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
