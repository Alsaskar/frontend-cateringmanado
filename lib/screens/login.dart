import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/screens/homepage.dart';
import 'package:cateringmanado_new/screens/main_dashboard.dart';
import 'package:cateringmanado_new/screens/register.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService auth = new AuthService();
  bool isLoading = false;

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
    void _signIn(noHp, password) async {
      var data = await auth.signIn(noHp, password);

      Future.delayed(Duration(seconds: 2), () {
        if (data['success']) {
          // jika customer yg login
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainDashboard(),
          ));

          // simpan data user ketika login
          AuthHelper.saveToken(data['token']);
          AuthHelper.saveUserId(data['id']);
          AuthHelper.LogIn();
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertMessage(
                title: 'Gagal Login',
                message: data['message'],
                color: Colors.red,
                txtBtn: 'OK',
              );
            },
          );

          // kosongkan value pada field password
          _passwordController.text = "";
        }

        setState(() {
          isLoading = false;
        });
      });
    }

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(180),
                      ),
                      color: Color(0xff6385FF),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 15),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Homepage(),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 40),
                    child: Text(
                      "Masuk",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 135, left: 40, right: 20),
                    child: Text(
                      "Masuk agar Anda dapat memesan catering",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 180),
                    child: Center(
                      child: Image.asset(
                        "assets/img/login.png",
                        height: 300,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Text(
                  "Masukkan Nomor Telepon Untuk Melanjutkan",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                  controller: _noHpController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    prefix: SizedBox(
                      width: 45,
                      child: Text(
                        "+62",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    labelText: "Nomor HP",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff6385FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: isLoading
                      ? TextButton(
                          onPressed: null, // tidak bisa di klik
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });

                            _signIn(
                                _noHpController.text, _passwordController.text);
                          },
                          child: Text(
                            "Masuk",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  },
                  child: Text(
                    "Belum punya akun? Daftar",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
