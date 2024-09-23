import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/login.dart';
import 'package:cateringmanado_new/screens/profil/change_informasi_catering.dart';
import 'package:cateringmanado_new/screens/profil/change_pass.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertConfirm.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilCatering extends StatefulWidget {
  const ProfilCatering({super.key});

  @override
  State<ProfilCatering> createState() => _ProfilCateringState();
}

class _ProfilCateringState extends State<ProfilCatering> {
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
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService.getDataLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            Map<dynamic, dynamic>? user = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Image.asset(
                      "assets/img/catering.png",
                      height: 100,
                      width: 150,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "${user!['firstname']} ${user['lastname']}",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text("Ubah Informasi"),
                    onTap: () async {
                      var catering =
                          await UserService.getProfilToko(user['id']);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeInformasiCatering(
                            data: {
                              'idUser': user['id'],
                              'firstname': user['firstname'],
                              'lastname': user['lastname'],
                              'email': user['email'],
                              'noHp': user['noHp'],
                              'fullname': catering['fullname'],
                              'alamat': catering['alamat'],
                              'noRekening': catering['noRekening'],
                              'namaRekening': catering['namaRekening'],
                              'namaBank': catering['namaBank'],
                            },
                          ),
                        ),
                      );
                    },
                    tileColor: Color(0xffe2e2e2),
                    leading: Icon(Icons.autorenew),
                  ),
                  ListTile(
                    title: Text("Ganti Password"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePass(
                            idUser: user['id'],
                          ),
                        ),
                      );
                    },
                    tileColor: Color(0xffe2e2e2),
                    leading: Icon(Icons.settings),
                  ),
                  ListTile(
                    title: Text("Keluar"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertConfirm(
                            title: 'Konfirmasi',
                            message: 'Yakin ingin keluar?',
                            clickKanan: () {
                              AuthHelper.LogOut();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            clickKiri: () {
                              Navigator.of(context).pop();
                            },
                            textKiri: 'Tidak',
                            textKanan: 'Ya',
                            btnStyleKiri: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.red,
                              ),
                            ),
                            colorTextKiri: Colors.white,
                            colorTextKanan: Colors.blue,
                          );
                        },
                      );
                    },
                    tileColor: Color(0xffefefef),
                    leading: Icon(Icons.logout),
                  ),
                  SizedBox(height: 20),
                  Text("CateringManado - Versi 1.0")
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
