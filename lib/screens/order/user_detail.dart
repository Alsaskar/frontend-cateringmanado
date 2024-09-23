import 'package:cateringmanado_new/screens/main_dashboard.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailOrder extends StatefulWidget {
  final String noInvoice;
  const UserDetailOrder({required this.noInvoice});

  @override
  State<UserDetailOrder> createState() => _UserDetailOrderState();
}

class _UserDetailOrderState extends State<UserDetailOrder> {
  Future<void> _checkShowAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showAlert = prefs.getBool('showAlert') ?? false;
    String messageAlert = prefs.getString('message') ?? '';

    if (showAlert) {
      setState(() {});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertMessage(
            title: 'Berhasil',
            message: messageAlert,
            color: Colors.green,
            txtBtn: 'OK',
          );
        },
      );

      await prefs.setBool('showAlert', false);
      await prefs.remove('message');
    }
  }

  @override
  void initState() {
    super.initState();

    _checkShowAlert();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainDashboard(),
          ),
        );

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainDashboard(),
                ),
              );
            },
          ),
          title: Text("Detail Order : #${widget.noInvoice}"),
        ),
        body: Center(
          child: Text("Halaman Detail Order Nomor ${widget.noInvoice}"),
        ),
      ),
    );
  }
}
