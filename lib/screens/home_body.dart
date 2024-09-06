import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../main.dart';
import '../services/download_service.dart';
import '/data/download_guide_steps.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  TextEditingController downloadLink = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Video Downloader"),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(gPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Steps:",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(gPadding),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: downloadSteps.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Text(
                    downloadSteps[index],
                  );
                },
              ),
            ),
            SizedBox(
              height: fieldHeight,
              child: TextFormField(
                controller: downloadLink,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(parentBorderRadius),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(childBorderRadius),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  suffixIcon: downloadLink.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            downloadLink.clear();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        )
                      : null,
                  hintText: "Add link to download",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(childBorderRadius),
                  ),
                ),
              ),
            ),
            const SizedBox(height: gPadding),
            SizedBox(
              height: buttonHeight,
              width: Get.width,
              child: FilledButton.tonal(
                onPressed: () async {
                  await Clipboard.getData(Clipboard.kTextPlain).then((value) {
                    downloadLink.text = value!.text!;
                  });
                  setState(() {});
                },
                child: const Text("Paste Clipboard"),
              ),
            ),
            const SizedBox(height: gPadding),
            SizedBox(
              height: buttonHeight,
              width: Get.width,
              child: FilledButton(
                onPressed: downloadLink.text.isNotEmpty
                    ? () async {
                        await DownloadService.checkAndRequestPermissions(
                            context);
                        appStates.startLoading();
                        DownloadService.getData(downloadLink.text);
                      }
                    : null,
                child: const Text("Get video"),
              ),
            ),
            const SizedBox(height: gPadding),
            Image.asset(
              "assets/media.jpg",
              width: double.infinity,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(parentBorderRadius),
                  child: child,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
