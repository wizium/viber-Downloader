import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:viberloader/screens/settings.dart';
import 'package:viberloader/screens/splash.dart';
import '/screens/downloads.dart';
import '/screens/home_body.dart';

int navBarIndex = 0;
TextEditingController downloadLink = TextEditingController();
String? clipboardText;
List screenBodies = [const HomeBody(), const Downloads()];
List screenTitles = ["Viber Downloader", "Downloads"];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isLoaded) {
          await adService.showInterstitialAd(() {
            SystemNavigator.pop();
          });
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Get.to(const Settings());
              },
              icon: const Icon(
                Icons.settings_rounded,
              ),
            ),
          ],
          centerTitle: true,
          title: Text(
            screenTitles[navBarIndex],
          ),
        ),
        body: screenBodies[navBarIndex],
        bottomNavigationBar: SalomonBottomBar(
          selectedItemColor: Theme.of(context).colorScheme.background,
          unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
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
              title: const Text(
                "Home",
              ),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                Icons.file_download_rounded,
              ),
              title: const Text(
                "Downloads",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
