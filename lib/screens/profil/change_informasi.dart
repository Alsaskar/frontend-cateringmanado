import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';

class ChangeInformasi extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChangeInformasi({required this.data});

  @override
  State<ChangeInformasi> createState() => _ChangeInformasiState();
}

class _ChangeInformasiState extends State<ChangeInformasi> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _noHp = TextEditingController();

  UserService userService = new UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstname.text = widget.data['firstname'];
    _lastname.text = widget.data['lastname'];
    _email.text = widget.data['email'];
    _noHp.text = widget.data['noHp'];

    SessionHelper.checkSesiLogin(context);
  }

  void _changeInformasi(Map<dynamic, dynamic> data) async {
    print(data['noRekening']);

    Future.delayed(Duration(seconds: 2), () async {
      try {
        var res = await userService.changeInformasi({
          'idUser': data['idUser'],
          'firstname': data['firstname'],
          'lastname': data['lastname'],
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertMessage(
              title: res['success'] ? 'Berhasil' : 'Gagal',
              message: res['message'],
              color: res['success'] ? Colors.green : Colors.red,
              txtBtn: 'OK',
            );
          },
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$err')),
        );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ubah Informasi")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/img/avatar-user.png",
                  height: 100,
                  width: 150,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _firstname,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  label: Text("Nama Depan"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _lastname,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  label: Text("Nama Belakang"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _email,
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  label: Text("Email"),
                  suffixIcon: widget.data['statusVerifEmail'] == 'sudah'
                      ? Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : IconButton(
                          onPressed: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertConfirm(
                            //       title: 'Verifikasi Email',
                            //       message:
                            //           'Email Anda belum diverifikasi. Ingin verifikasi?',
                            //       onClick: () {
                            //         print("Verifikasi Email");
                            //       },
                            //     );
                            //   },
                            // );
                          },
                          icon: Icon(
                            Icons.clear,
                            color: Colors.red,
                          ),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _noHp,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.verified, color: Colors.green),
                  contentPadding: EdgeInsets.all(10),
                  label: Text("Nomor HP"),
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
                          _changeInformasi({
                            'idUser': widget.data['idUser'].toString(),
                            'firstname': _firstname.text,
                            'lastname': _lastname.text,
                          });
                        },
                        child: Text(
                          "Ubah Informasi",
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
    );
  }
}
