import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../functions/get_video_data.dart';
import '/screens/home.dart';
import '/data/download_guide_steps.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                orientation == Orientation.portrait
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Steps:",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : const SizedBox(),
                orientation == Orientation.portrait
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: downloadSteps.length,
                          itemBuilder: (context, index) {
                            return Text(
                              downloadSteps[index],
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
                TextFormField(
                  controller: downloadLink,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
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
                    hintText: "Paste link",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Clipboard.getData(Clipboard.kTextPlain)
                              .then((value) {
                            downloadLink.text = value!.text!;
                          });
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.paste_rounded,
                        ),
                        label: const Text(
                          "Paste",
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: downloadLink.text.isNotEmpty
                            ? () async {
                                await getVideoDetails(downloadLink.text);
                              }
                            : null,
                        icon: const Icon(
                          Icons.file_download_rounded,
                        ),
                        label: const Text(
                          "Download",
                        ),
                      )
                    ],
                  ),
                ),
                orientation == Orientation.portrait
                    ? Image.network(
                        "https://prettylinks.com/wp-content/uploads/2019/06/Social-Media-Integration@2x-1024x745.png",
                        errorBuilder: (context, error, stackTrace) {
                          return Expanded(
                            child: Container(
                              color: Colors.red,
                            ),
                          );
                        },
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: child,
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
