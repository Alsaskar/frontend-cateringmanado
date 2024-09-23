import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';

class ChangePass extends StatefulWidget {
  final String idUser;

  const ChangePass({required this.idUser});

  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  UserService userService = new UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    void _changePass(oldPass, newPass, confirmPass, idUser) async {
      var data = await userService.changePass({
        'old_pass': oldPass,
        'new_pass': newPass,
        'reply_new_pass': confirmPass
      }, idUser);

      Future.delayed(Duration(seconds: 2), () {
        // kosongkan value pada field password
        _oldPassword.text = "";
        _newPassword.text = "";
        _confirmPassword.text = "";

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertMessage(
              title: data['success'] == true ? 'Berhasil' : 'Gagal',
              message: data['message'],
              color: data['success'] == true ? Colors.green : Colors.red,
              txtBtn: 'OK',
            );
          },
        );

        setState(() {
          _isLoading = false;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Ganti Password")),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _oldPassword,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                label: Text("Password Lama"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newPassword,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                label: Text("Password Baru"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPassword,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                label: Text("Ulangi Password Baru"),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff47b0ff),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isLoading
                  ? TextButton(
                      onPressed: null, // tidak bisa di klik
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        _changePass(_oldPassword.text, _newPassword.text,
                            _confirmPassword.text, widget.idUser);

                        setState(() {
                          _isLoading = true;
                        });
                      },
                      child: Text(
                        "Ganti Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
