import 'package:flutter/material.dart';
import 'package:get/get.dart';

errorSheet(BuildContext context, {required String errorMessage}) {
  Get.bottomSheet(
    Container(
      height: Get.height * .25,
      width: Get.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(Get.height * .05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Alert",
              style: Theme.of(context).textTheme.headlineMedium!.merge(
                    const TextStyle(
                      color: Colors.red,
                    ),
                  ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                errorMessage,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
