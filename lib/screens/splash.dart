import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viberloader/main.dart';
import 'package:viberloader/screens/home.dart';
import "package:animated_text_kit/animated_text_kit.dart";
import 'package:viberloader/screens/onbaording.dart';
import 'package:viberloader/services/ad_service.dart';

late AdServices adService;
bool isLoaded = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> animatedTexts = ["Viber ", "Video", "Downloader"];
  int animatedTextIndex = 1;
  @override
  void initState() {
    super.initState();
    adService = AdServices();
    adService.interstitialAdLoad();
    setState(() {});
    Future.delayed(const Duration(seconds: 4), () {
      !isDark
          ? {
              Get.changeThemeMode(ThemeMode.dark),
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      Theme.of(context).colorScheme.inversePrimary,
                ),
              )
            }
          : {
              Get.changeThemeMode(ThemeMode.light),
              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      Theme.of(context).colorScheme.primary,
                ),
              )
            };
      final ifFirstTime = preferences.getBool("ifFirstTime") ?? true;
      if (ifFirstTime) {
        preferences.setBool("ifFirstTime", false);
        Get.offAll(
          const OnBoarding(),
        );
      } else {
        Get.offAll(
          const HomePage(),
        );
      }
    });
    _startTextAnimation();
  }

  void _startTextAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        animatedTextIndex = 2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/download.png",
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
                child: AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(animatedTexts[0]),
                    TyperAnimatedText(animatedTexts[1]),
                    TyperAnimatedText(animatedTexts[2]),
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
