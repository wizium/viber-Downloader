import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../screens/home.dart';
import "package:animated_text_kit/animated_text_kit.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int animatedTextIndex = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(gPadding),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(childBorderRadius),
                  child: Image.asset(
                    "assets/icon.png",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      "Video Downloader",
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
