import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/functions/settings_functions.dart';
import '/data/settings.dart';
import 'splash.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void dispose() {
    if (isLoaded) {
      adService.showInterstitialAd(() {
        adService.interstitialAdLoad();
      });
    } else {
      adService.interstitialAdLoad();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preferences",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: settingsTitles.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          settingFunctions[index](context);
                          setState(() {});
                        },
                        leading: Icon(settingsIcons[index]),
                        title: Text(
                          settingsTitles[index],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 55, right: 10),
                        child: Divider(
                          height: Get.height * .01,
                          color: Colors.grey.withOpacity(.2),
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Version $version",
              ),
            )
          ],
        ),
      ),
    );
  }
}
