import 'dart:io';
import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:share_plus/share_plus.dart';
import '../config.dart';
import '../widget/about_me.dart';
import '/main.dart';
import 'package:url_launcher/url_launcher.dart';

List settingsTitles = [
  "Tell a Friend",
  "Feedback",
  "Theme mode",
  "Privacy Policy",
  "Disclaimer",
  "About us",
];
List settingsIcons = [
  Icons.share_outlined,
  CupertinoIcons.text_bubble,
  Icons.light_mode_outlined,
  Icons.privacy_tip_outlined,
  Icons.warning_amber_rounded,
  Icons.info_outline,
];
List<Function> settingFunctions = [
  (context) async {
    await Share.share(
      "🚀 Video Downloader 🎥 Download your favorite videos instantly! 📲✨ Fast, easy, and in HD quality. Try it now: https://play.google.com/store/apps/details?id=com.wizium.viber.downloader 🚀📥",
    );
  },
  (context) {
    BetterFeedback.of(context).show((feedback) async {
      sendEmail(feedback.screenshot, feedback.text);
    });
  },
  (context) async {
    appStates.themeStateSave(!appStates.dark.value);
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
            """Video Downloader is not a YouTube Downloader. Due to restrictions of the Google Web Store Policies and Developer Program Policies, we cannot download YouTube Videos. Thank you for understanding. Video Downloader doesn't collect passwords, credentials, security questions, or personal identification numbers. Video Downloader has disclosed the following information regarding the collection and usage of your data. While Video Downloader strives to provide only quality links to useful and ethical websites, we have no control over the content and nature of these sites. Please be sure to check the Privacy Policies of this App as well as their "Terms of Service" before engaging in any business or downloading any content/video. By using our App, you hereby consent to our disclaimer and agree to its terms.""",
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
      applicationName: appName,
      applicationVersion: version,
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(childBorderRadius),
        child: Image.asset(
          "assets/icon.png",
          height: 70,
          width: 70,
          fit: BoxFit.cover,
        ),
      ),
      children: [
        const SizedBox(height: 10),
        const Text("This is a freemium video downloader app."),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () {
            aboutMeDialog();
          },
          child: const Text("About Developer"),
        ),
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
    ..subject = 'Feedback To Video Downloader'
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
