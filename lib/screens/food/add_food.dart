import 'dart:io';

import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/food/list_food.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class AddFood extends StatefulWidget {
  final String idUser;
  const AddFood({required this.idUser});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final picker = ImagePicker();
  File? _photo;
  String? _filename;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nama = new TextEditingController();
  final TextEditingController _harga = new TextEditingController();
  final TextEditingController _deskripsi = new TextEditingController();
  bool _isLoading = false;

  final FoodService _foodService = FoodService();

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
      return 'Foto Makanan Harus Dipilih';
    }

    return null;
  }

  Future<void> _submitData(String idUser) async {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () async {
      try {
        var getDataToko =
            await UserService.getProfilToko(idUser); // ambil data catering

        final res = await _foodService.add(
          getDataToko['id'],
          _nama.text,
          int.parse(_harga.text),
          _deskripsi.text,
          _photo!,
        );

        // bila berhasil tambah makanan
        if (res['success']) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('showAlert', true);
          await prefs.setString('message', res['message']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ListFood(
                idUser: widget.idUser,
              ),
            ),
          );
        }
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $err')),
        );

        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Makanan Baru"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Silahkan menambahkan makanan untuk Toko Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Divider(),
                TextFormField(
                  controller: _nama,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    label: Text("Nama Makanan"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Makanan tidak boleh kosong';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _harga,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    label: Text("Harga"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _deskripsi,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    label: Text("Deskripsi Singkat"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: getImage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file),
                        _photo == null
                            ? Text("Upload Photo")
                            : Text(_filename!),
                      ],
                    ),
                  ),
                ),
                Divider(
                  height: 25,
                  color: Colors.black,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff47b0ff),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isLoading
                      ? TextButton(
                          onPressed: null, // tidak bisa di klik
                          child: Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
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
                                _submitData(widget.idUser);
                              }
                            }
                          },
                          child: Text(
                            "Simpan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
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
