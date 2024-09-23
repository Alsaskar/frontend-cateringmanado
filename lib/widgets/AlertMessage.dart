import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  final String txtBtn;

  const AlertMessage({
    required this.title,
    required this.color,
    required this.message,
    required this.txtBtn,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Menutup dialog
          },
          child: Text(
            txtBtn,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
