import 'package:flutter/material.dart';
import '../config.dart';
import '../widget/back_button.dart';
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
        title: const Text("Preferences"),
        centerTitle: true,
        leading: const NewBackButton(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(gPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListView.builder(
                itemCount: settingsTitles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                      Divider(
                        height: 5,
                        color: Colors.grey.withOpacity(.5),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: gPadding * 3),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Text("Version $version"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
