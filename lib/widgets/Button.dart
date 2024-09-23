import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function() handleClick;
  final Color btnColor;
  final String text;
  final Color textColor;
  final double? width;
  final double height;
  final EdgeInsetsGeometry margin;
  final double borderRadius;

  const Button({
    required this.handleClick,
    required this.btnColor,
    required this.text,
    required this.textColor,
    this.width,
    required this.height,
    required this.margin,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextButton(
        onPressed: handleClick,
        child: Text(
          "${text}",
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
