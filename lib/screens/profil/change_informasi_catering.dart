import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';

class ChangeInformasiCatering extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChangeInformasiCatering({required this.data});

  @override
  State<ChangeInformasiCatering> createState() =>
      _ChangeInformasiCateringState();
}

class _ChangeInformasiCateringState extends State<ChangeInformasiCatering> {
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _noHp = TextEditingController();

  final TextEditingController _namaToko = TextEditingController();
  final TextEditingController _alamatToko = TextEditingController();

  final TextEditingController _noRekening = TextEditingController();
  final TextEditingController _namaRekening = TextEditingController();
  String? _selectedNamaBank = '...';

  UserService userService = new UserService();
  bool _isLoading = false;

  List<String> _listNamaBank = [
    "...",
    "BCA",
    "BNI",
    "BRI",
    "Bank SULUT",
  ];

  @override
  void initState() {
    super.initState();
    _firstname.text = widget.data['firstname'];
    _lastname.text = widget.data['lastname'];
    _email.text = widget.data['email'];
    _noHp.text = widget.data['noHp'];
    _namaToko.text = widget.data['fullname'];
    _alamatToko.text = widget.data['alamat'];
    _noRekening.text = widget.data['noRekening'];
    _namaRekening.text = widget.data['namaRekening'];

    setState(() {
      _selectedNamaBank = _listNamaBank.contains(widget.data['namaBank'])
          ? widget.data['namaBank']
          : '...'; // fallback ke default jika namaBank tidak valid
    });

    SessionHelper.checkSesiLogin(context);
  }

  void _changeInformasi(Map<dynamic, dynamic> data) async {
    Future.delayed(Duration(seconds: 2), () async {
      try {
        print(data);
        var res = await userService.changeInformasi({
          'idUser': data['idUser'],
          'firstname': data['firstname'],
          'lastname': data['lastname'],
          'fullname': data['fullname'],
          'alamat': data['alamatToko'],
          'noRekening': data['noRekening'],
          'namaRekening': data['namaRekening'],
          'namaBank': data['namaBank'],
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
        print(err);
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
                  suffixIcon: Icon(Icons.verified, color: Colors.green),
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
              SizedBox(height: 15),
              Column(
                children: [
                  TextField(
                    controller: _namaToko,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      label: Text("Nama Catering"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _alamatToko,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      label: Text("Alamat Catering"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Data Rekening",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Customer akan melakukan pembayaran melalui no rekening Anda",
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _noRekening,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      label: Text("No Rekening"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _namaRekening,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      label: Text("Nama Rekening"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Icon(Icons.wallet),
                        value: _selectedNamaBank != null &&
                                _listNamaBank.contains(_selectedNamaBank)
                            ? _selectedNamaBank
                            : '...', // fallback ke default jika value tidak valid
                        hint: Text('Pilih Bank'),
                        isExpanded: true,
                        items: _listNamaBank.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value == '...' ? 'Pilih Bank' : value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedNamaBank = newValue ?? '...';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                            'fullname': _namaToko.text,
                            'alamatToko': _alamatToko.text,
                            'namaRekening': _namaRekening.text,
                            'noRekening': _noRekening.text,
                            'namaBank': _selectedNamaBank,
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
