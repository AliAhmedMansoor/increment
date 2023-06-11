import 'package:flutter/material.dart';
import 'package:incrementapp/themes/colours.dart';

class MySecondaryButton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;
  final Color color;
  final Color borderColor;
  final double borderWidth;

  const MySecondaryButton({
    Key? key,
    required this.onTap,
    required this.child,
    this.color = Colors.transparent,
    this.borderColor = Colours.unfocusedBorder,
    this.borderWidth = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: child,
      ),
    );
  }
}
