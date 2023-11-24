import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool buttonState = true;

class CustomButton extends StatefulWidget {
  final String childText;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double height;
  final double width;
  const CustomButton(
      {super.key,
      required this.icon,
      required this.childText,
      required this.color,
      required this.onPressed,
      required this.height,
      required this.width});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * .01),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTapDown: (details) {
            buttonState = false;
            setState(() {});
          },
          onTapUp: (details) {
            buttonState = true;
            setState(() {});
            widget.onPressed();
          },
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color:
                  buttonState ? widget.color : Color(widget.color.value - 90),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.childText,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
