import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viberloader/main.dart';
import 'package:viberloader/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
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
      Get.offAll(
        const HomePage(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/download.png"),
      ),
    );
  }
}
