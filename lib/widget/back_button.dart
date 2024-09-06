import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewBackButton extends StatelessWidget {
  const NewBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Get.back();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
