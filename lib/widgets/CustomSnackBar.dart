import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final String actionLabel;
  final void Function()? onPressed;

  const CustomSnackBar({
    required this.message,
    required this.actionLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8.0),
            GestureDetector(
              onTap: onPressed,
              child: Text(
                actionLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
