import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/services/PayService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class UangMuka extends StatefulWidget {
  final int grandTotal;
  final String noInvoice;
  final String idItemMaster;
  final Map<dynamic, dynamic> dataAdminToko;

  const UangMuka({
    required this.grandTotal,
    required this.noInvoice,
    required this.idItemMaster,
    required this.dataAdminToko,
  });

  @override
  State<UangMuka> createState() => _UangMukaState();
}

class _UangMukaState extends State<UangMuka> {
  double _totalPembayaran = 0;
  int _buktiTf = 0; // cek apa sudah kirim bukti tf atau tidak

  final picker = ImagePicker();
  File? _photo;
  String? _filename;
  bool _isLoading = false;

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
      return 'Bukti Pembayaran masih kosong';
    }

    return null;
  }

  Future<void> _sendBuktiTf() async {
    Future.delayed(Duration(seconds: 2), () async {
      if (_validateImage() != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertMessage(
              title: 'Oppss...',
              message: _validateImage()!,
              color: Colors.red,
              txtBtn: 'OK',
            );
          },
        );

        setState(() {
          _isLoading = false;
        });
      } else {
        var res = await PayService().payStepOne(widget.idItemMaster,
            widget.noInvoice, _totalPembayaran.toString(), _photo!);

        if (res['success']) {
          _cekStatus();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertMessage(
                title: 'Berhasil',
                message: res['message'],
                color: Colors.green,
                txtBtn: 'OK',
              );
            },
          );

          setState(() {
            _isLoading = false;
          });
        }
      }
    });

    setState(() {
      _isLoading = true;
    });
  }

  Future<void> _cekStatus() async {
    var res =
        await PayService().cekStatus(widget.idItemMaster, widget.noInvoice);

    setState(() {
      _buktiTf = res['stepOne'];
    });
  }

  @override
  void initState() {
    super.initState();

    _cekStatus();

    setState(() {
      double hitung = widget.grandTotal * 0.50; // 50%
      _totalPembayaran = hitung;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bayar Uang Muka",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.blue,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pembayaran Uang Muka",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Kontak Toko",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Hubungi Toko untuk mengirim bukti TF lebih cepat atau hal yang lain",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nomor HP : ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.dataAdminToko['user']['noHpToko']} ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email : ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.dataAdminToko['user']['emailToko']} ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    "Data Rekening",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nomor Rekening : ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.dataAdminToko['noRekening']} ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Nama Rekening : ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.dataAdminToko['namaRekening']} ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BANK : ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${widget.dataAdminToko['namaBank']} ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Rp. ${Hooks.formatHargaId(_totalPembayaran.toInt())}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            _buktiTf > 0
                ? Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.green,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Anda telah mengirimkan Bukti Transfer Uang Muka",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Silahkan menunggu sampai Status Order diubah oleh Admin Toko, baru Anda melakukan Pembayaran tahap 2 yaitu Uang Tengah",
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Silahkan melakukan pembayaran uang muka dengan total pembayaran dan dikirimkan ke Rekening yg tertera diatas",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Kirim Bukti Transfer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                                    ? Text("Upload Foto")
                                    : Text(_filename!),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Button(
                          handleClick: () {
                            if (_isLoading == false) {
                              _sendBuktiTf();
                            }
                          },
                          btnColor: Colors.blue,
                          text: _isLoading ? "Loading..." : "Kirim",
                          textColor: Colors.white,
                          width: double.infinity,
                          height: 40,
                          margin: EdgeInsets.all(0),
                          borderRadius: 50,
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
