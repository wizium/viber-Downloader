import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

int groupValue = 0;

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: CustomSlidingSegmentedControl(
          initialValue: groupValue,
          isStretch: true,
          thumbDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          children: const {
            0: Text("Video"),
            1: Text("Audio"),
          },
          onValueChanged: (value) {
            setState(() {
              groupValue = value;
            });
          },
        ),
      ),
      body: Center(
        child: Text("Downloads $groupValue"),
      ),
    );
  }
}
