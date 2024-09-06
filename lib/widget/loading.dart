import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inverseSurface,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                12,
              ),
            ),
          ),
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Processing",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
