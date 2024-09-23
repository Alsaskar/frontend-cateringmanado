import 'package:flutter/material.dart';

class AlertButton extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  final String txtBtn;
  final void Function() handleClick;

  const AlertButton({
    required this.title,
    required this.color,
    required this.message,
    required this.txtBtn,
    required this.handleClick,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
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
            onPressed: handleClick,
            child: Text(
              txtBtn,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
