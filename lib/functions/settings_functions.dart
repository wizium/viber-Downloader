import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:share_plus/share_plus.dart';
import '/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '/screens/onbaording.dart';

const version = "1.0.2+13";
List<Function> settingFunctions = [
  (context) {
    Get.isDarkMode
        ? {
            Get.changeThemeMode(ThemeMode.light),
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor:
                    Theme.of(context).colorScheme.inversePrimary,
              ),
            )
          }
        : null;

    Get.to(const OnBoarding());
  },
  (context) async {
    await Share.share(
      """🚀 Viber Video Downloader 🎥
Download your favorite videos instantly! 📲✨ Fast, easy, and in HD quality. Try it now: https://play.google.com/store/apps/details?id=com.wizium.viber.downloader 🚀📥 #VideoDownloader #DownloadNow""",
      subject: 'Check out this beautiful video downloader app',
    );
  },
  (context) {
    BetterFeedback.of(context).show((feedback) async {
      sendEmail(feedback.screenshot, feedback.text);
    });
  },
  (context) async {
    Get.isDarkMode
        ? Get.changeThemeMode(ThemeMode.light)
        : Get.changeThemeMode(ThemeMode.dark);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
    await preferences.setBool("isDark", Get.isDarkMode);
    Get.snackbar("Theme", "Changed To ${!Get.isDarkMode ? "🌙" : "🌞"}");
  },
  (context) async {
    try {
      await FlutterDownloader.loadTasks().then((value) async {
        for (int i = 0; i <= value!.length; i++) {
          String key = box.getAt(i)!;
          await CachedNetworkImage.evictFromCache(key);
        }
      });

      Get.snackbar("Cache", "Cleared Successfully. 🧽🗑");
    } catch (e) {
      Get.snackbar("No cache", "its already clean. 😇🥳");
    }
  },
  (context) async {
    await launchUrl(
      Uri.parse(
        "https://sites.google.com/view/viberdownloader",
      ),
      mode: LaunchMode.inAppWebView,
    );
  },
  (context) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Disclaimer"),
          content: const Text(
            """Viber Video Downloader is not a YouTube Downloader. Due to restrictions of the Google Web Store Policies and Developer Program Policies, we cannot download YouTube Videos. Thank you for understanding. Video Downloader doesn't collect passwords, credentials, security questions, or personal identification numbers. Video Downloader has disclosed the following information regarding the collection and usage of your data. While Video Downloader strives to provide only quality links to useful and ethical websites, we have no control over the content and nature of these sites. Please be sure to check the Privacy Policies of this App as well as their "Terms of Service" before engaging in any business or downloading any content/video. By using our App, you hereby consent to our disclaimer and agree to its terms.""",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          ],
        );
      },
    );
  },
  (context) {
    showAboutDialog(
      context: context,
      applicationName: "Viber video downloader",
      applicationVersion: version,
      applicationIcon: Image.asset(
        "assets/download.png",
        height: 40,
        width: 40,
      ),
      children: [
        RichText(
          text: TextSpan(
            text: "Developed by: ",
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (!await launchUrl(
                      Uri.parse(
                        "https://github.com/AbubakarL",
                      ),
                    )) {
                      throw Exception('Could not launch');
                    }
                  },
                text: "Muhammad Abubakar ",
                style: const TextStyle(
                  color: Colors.blue,
                ),
              ),
              const TextSpan(
                text: "Contact us at ",
              ),
              TextSpan(
                text: "Qsssoftnic@gmail.com ",
                style: const TextStyle(
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchUrl(
                      Uri.parse(
                        "mailto:Qsssoftnic@gmail.com",
                      ),
                    );
                  },
              ),
              const TextSpan(text: "for Business queries. "),
              TextSpan(
                text: "Privacy Policy",
                style: const TextStyle(
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchUrl(
                      Uri.parse(
                        "https://sites.google.com/view/viberdownloader",
                      ),
                      mode: LaunchMode.inAppWebView,
                    );
                  },
              ),
            ],
          ),
        )
      ],
    );
  },
];

void sendEmail(Uint8List image, messageText) async {
  File tempFile = File("${directory.path}/.Screenshot.png");
  await tempFile.writeAsBytes(image);
  final smtpServer = gmail('qsssoftnic@gmail.com', 'vulu fwwi psvf zoqh');

  final message = Message()
    ..from = const Address('qsssoftnic@gmail.com')
    ..recipients.add(
      const Address('wizium123@gmail.com'),
    )
    ..subject = 'Feedback To viber Video Downloader'
    ..text = messageText
    ..html = '<h1>Reference Image</h1>'
    ..attachments.add(
      FileAttachment(
        tempFile,
        fileName: "Screenshot.png",
      )..location = Location.attachment,
    );

  try {
    await send(message, smtpServer);
    Get.snackbar("Success", "Thank you for your feedback");
  } catch (e) {
    Get.snackbar("Sorry", "Something went wrong");
  }
}
