import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/screens/login.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:flutter/material.dart';

class SessionHelper {
  // jika token expired atau habis waktu
  // akan muncul pesan, dan akan terlogout
  static Future<void> checkSesiLogin(BuildContext context) async {
    var dataUser = await AuthService.getDataLoggedIn();

    if (dataUser['loggedIn'] == false) {
      // token habis
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              title: Text(
                "Sesi Habis",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: Text(
                "Anda akan keluar dari sistem dan silahkan masuk lagi",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: () {
                    AuthHelper.LogOut();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
                  },
                  child: Text(
                    "Ya",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
