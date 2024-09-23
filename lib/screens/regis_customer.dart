import 'package:cateringmanado_new/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:cateringmanado_new/screens/login.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisCustomer extends StatefulWidget {
  const RegisCustomer({super.key});

  @override
  State<RegisCustomer> createState() => _RegisCustomerState();
}

class _RegisCustomerState extends State<RegisCustomer> {
  final TextEditingController _namaDepanController = TextEditingController();
  final TextEditingController _namaBelakangController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cPassController = TextEditingController();
  AuthService authService = AuthService();
  bool _isLoading = false;

  void _regis(String firstname, String lastname, String noHp, String email,
      String password, String c_pass, String role) async {
    Future.delayed(Duration(seconds: 2), () async {
      var data = await authService.regisCustomer(
          firstname, lastname, noHp, email, password, c_pass);

      // bila berhasil, maka form akan dikosongkan
      if (data['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('showAlert', true);
        await prefs.setString('message', data['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertMessage(
            title: data['success'] ? 'Berhasil' : 'Gagal',
            message: data['message'],
            color: data['success'] ? Colors.green : Colors.red,
            txtBtn: 'OK',
          );
        },
      );

      setState(() {
        _isLoading = false;
      });
    });

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Color(0xff999999),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 15),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
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
                      "Daftar Customer",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 140, left: 40, right: 20),
                    child: Text(
                      "Daftar agar Anda bisa memesan makanan catering",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 210,
                      left: 40,
                      right: 20,
                    ),
                    child: Image.asset(
                      "assets/img/customer.png",
                      height: 80,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: TextField(
                  controller: _namaDepanController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Nama Depan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextField(
                  controller: _namaBelakangController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    labelText: "Nama Belakang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextField(
                  controller: _noHpController,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
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
                  controller: _emailController,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextField(
                  controller: _passController,
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
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                child: TextField(
                  controller: _cPassController,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Ulangi Password",
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
                  child: _isLoading
                      ? TextButton(
                          onPressed: null, // tidak bisa di klik
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            _regis(
                              _namaDepanController.text,
                              _namaBelakangController.text,
                              _noHpController.text,
                              _emailController.text,
                              _passController.text,
                              _cPassController.text,
                              'customer', // role
                            );
                          },
                          child: Text(
                            "Daftar",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
