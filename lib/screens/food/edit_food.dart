import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/food/list_food.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditFood extends StatefulWidget {
  final String id; // id makanan
  final String nama;
  final int harga;
  final String deskripsi;
  final String idUser;

  const EditFood({
    required this.id,
    required this.nama,
    required this.harga,
    required this.deskripsi,
    required this.idUser,
  });

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nama = new TextEditingController();
  final TextEditingController _harga = new TextEditingController();
  final TextEditingController _deskripsi = new TextEditingController();
  bool _isLoading = false;

  Future<void> _submitData() async {
    Future.delayed(Duration(seconds: 2), () async {
      try {
        var res = await FoodService().updateData(widget.id, {
          'nama': _nama.text,
          'harga': _harga.text,
          'deskripsi': _deskripsi.text,
        });

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
        print(err);
      }

      setState(() {
        _isLoading = false;
      });
    });

    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _nama.text = widget.nama;
    _harga.text = widget.harga.toString();
    _deskripsi.text = widget.deskripsi;

    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Makanan"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Edit Makanan - ${widget.nama}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Divider(),
                SizedBox(height: 10),
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
                              _submitData();
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
