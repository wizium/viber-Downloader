import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:get/get.dart';
import 'package:viberloader/screens/home.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        controllerColor: Colors.amber,
        onFinish: () {
          Get.offAll(
            const HomePage(),
          );
        },
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        finishButtonText: 'Done',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        skipTextButton: const Text('Skip'),
        centerBackground: true,
        background: [
          Image.asset(
            'assets/0.PNG',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/1.PNG',
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/2.PNG',
            fit: BoxFit.cover,
          ),
        ],
        totalPage: 3,
        speed: 1.8,
        pageBodies: const [
          SizedBox(),
          SizedBox(),
          SizedBox(),
        ],
      ),
    );
  }
}
