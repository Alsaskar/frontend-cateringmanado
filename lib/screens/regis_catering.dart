import 'dart:io';

import 'package:cateringmanado_new/screens/login.dart';
import 'package:cateringmanado_new/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class RegisCatering extends StatefulWidget {
  const RegisCatering({super.key});

  @override
  State<RegisCatering> createState() => _RegisCateringState();
}

class _RegisCateringState extends State<RegisCatering> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaDepanController = TextEditingController();
  final TextEditingController _namaBelakangController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cPassController = TextEditingController();
  final TextEditingController _fullnameController =
      TextEditingController(); // nama catering
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  final picker = ImagePicker();
  File? _photo;
  String? _filename;

  AuthService authService = AuthService();
  bool _isLoading = false;

  void _regis(
      String firstname,
      String lastname,
      String nik,
      File photo,
      String noHp,
      String email,
      String fullname,
      String alamat,
      String password,
      String c_pass) async {
    Future.delayed(Duration(seconds: 2), () async {
      var data = await authService.regisCatering(firstname, lastname, nik,
          photo, noHp, email, fullname, alamat, password, c_pass);

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

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _photo = File(pickedFile.path);
        _filename = path.basename(pickedFile.path);
      });
    }
  }

  String? _validateImage() {
    if (_photo == null) {
      return 'Foto KTP Masih Kosong';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(180),
                        ),
                        color: Color(0xff2986cc),
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
                        "Daftar Catering",
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
                        "Daftar sekarang agar Anda bisa menjual makanan catering Anda",
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
                        "assets/img/catering.png",
                        height: 80,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Text(
                    "Data Pribadi",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: _namaDepanController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "Nama Depan Anda",
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
                      labelText: "Nama Belakang Anda",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: _nikController,
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "NIK",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: getImage,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file),
                          _photo == null
                              ? Text("Upload KTP")
                              : Text(_filename!),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: _photo == null
                      ? Container(
                          width: double.infinity,
                          height: 151.2,
                          decoration: BoxDecoration(color: Colors.grey),
                          child: Center(
                            child: Text(
                              "Preview Foto KTP",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Image.file(
                            _photo!,
                            height: 151.2,
                            width: double.infinity,
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
                      labelText: "Nomor HP Anda",
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
                      labelText: "Email Anda",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                // Data Catering
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Text(
                    "Data Catering",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: _fullnameController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "Nama Catering",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextField(
                    controller: _alamatController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: "Alamat Catering",
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
                              if (_formKey.currentState!.validate()) {
                                if (_validateImage() != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(_validateImage()!)),
                                  );
                                } else {
                                  _regis(
                                    _namaDepanController.text,
                                    _namaBelakangController.text,
                                    _nikController.text,
                                    _photo!,
                                    _noHpController.text,
                                    _emailController.text,
                                    _fullnameController.text,
                                    _alamatController.text,
                                    _passController.text,
                                    _cPassController.text,
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Daftar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
