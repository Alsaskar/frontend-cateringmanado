import 'package:flutter/material.dart';

class AlertConfirm extends StatelessWidget {
  final String title;
  final String message;
  final void Function() clickKiri;
  final void Function() clickKanan;
  final ButtonStyle? btnStyleKiri;
  final ButtonStyle? btnStyleKanan;
  final String textKiri;
  final String textKanan;
  final Color colorTextKiri;
  final Color colorTextKanan;

  const AlertConfirm({
    required this.title,
    required this.message,
    required this.clickKiri,
    required this.clickKanan,
    this.btnStyleKiri,
    this.btnStyleKanan,
    required this.textKiri,
    required this.textKanan,
    required this.colorTextKiri,
    required this.colorTextKanan,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(
              textKiri,
              style: TextStyle(
                color: colorTextKiri,
              ),
            ),
            style: btnStyleKiri,
            onPressed: clickKiri,
          ),
          TextButton(
            child: Text(
              textKanan,
              style: TextStyle(
                color: colorTextKanan,
              ),
            ),
            style: btnStyleKanan,
            onPressed: clickKanan,
          ),
        ],
      ),
    );
  }
}
