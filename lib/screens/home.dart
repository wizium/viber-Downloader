import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:viberloader/functions/gat_path.dart';
import 'package:viberloader/functions/permission.dart';
import 'package:viberloader/screens/splash.dart';
import 'package:viberloader/widget/home_drawer.dart';
import '/screens/downloads.dart';
import '/screens/home_body.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
    getStoragePermission(context);
    getStoragePath();
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
        key: scaffoldKey,
        drawer: const HomeDrawer(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
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
