import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../services/download_service.dart';
import '/screens/downloads.dart';
import '/screens/home_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int navBarIndex = 0;
  String? clipboardText;
  List screenBodies = [const HomeBody(), const Downloads()];
  @override
  Widget build(BuildContext context) {
    DownloadService.checkAndRequestPermissions(context);
    DownloadService.getStoragePath();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: screenBodies[navBarIndex],
      bottomNavigationBar: SalomonBottomBar(
        unselectedItemColor: Theme.of(context).colorScheme.inverseSurface,
        selectedItemColor: Theme.of(context).colorScheme.surface,
        curve: Curves.fastLinearToSlowEaseIn,
        backgroundColor: Theme.of(context).colorScheme.primary,
        currentIndex: navBarIndex,
        onTap: (index) {
          setState(() {
            navBarIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.home_rounded,
            ),
            title: const Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: const Icon(
              Icons.file_download_rounded,
            ),
            title: const Text("Downloads"),
          ),
        ],
      ),
    );
  }
}
