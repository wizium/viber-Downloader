import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/functions/settings_functions.dart';
import '/data/settings.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
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
                        },
                        // trailing: const Icon(null),
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
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Version .6.6.6",
              ),
            )
          ],
        ),
      ),
    );
  }
}
