import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/services/PayService.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewCheckPembayaran extends StatefulWidget {
  final String idItemMaster;

  const ViewCheckPembayaran({required this.idItemMaster});

  @override
  State<ViewCheckPembayaran> createState() => _ViewCheckPembayaranState();
}

class _ViewCheckPembayaranState extends State<ViewCheckPembayaran> {
  Map<dynamic, dynamic> _data = {};
  bool _isLoading = true;
  String? _errorMessage;

  Future<void> _cekPembayaran() async {
    try {
      var res = await PayService().fetchData(widget.idItemMaster);

      setState(() {
        _data = res['result'];
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _errorMessage = "Belum melakukan Pembayaran Uang Muka atau DP";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Pembayaran"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lihat Pembayaran",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Cek apakah pemesan telah melakukan pembayaran dari uang muka alias tahap 1, sampai tahap 2 dan 3",
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 217, 218),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Uang Muka / Tahap 1",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_data['proofOne'] != '') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImagePay(
                                              urlImage: _data['proofOne'],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _data['proofOne'] == ''
                                          ? Image.asset(
                                              "assets/img/no-image.png",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "${Config.urlStatic}/img-pay/${_data['proofOne']}",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _data['stepOne'] == 'yes'
                                          ? Text(
                                              "Sudah Dibayar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                              ),
                                            )
                                          : Text(
                                              "Belum Dibayar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Rp. ${Hooks.formatHargaId(_data['jumlahUangMuka'])}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 217, 218),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Uang Tengah / Tahap 2",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_data['proofTwo'] != '') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImagePay(
                                              urlImage: _data['proofTwo'],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _data['proofTwo'] == ''
                                          ? Image.asset(
                                              "assets/img/no-image.png",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "${Config.urlStatic}/img-pay/${_data['proofTwo']}",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _data['stepTwo'] == 'yes'
                                          ? Text(
                                              "Sudah Dibayar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                              ),
                                            )
                                          : Text(
                                              "Belum Dibayar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Rp. ${Hooks.formatHargaId(_data['jumlahUangTengah'])}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 216, 217, 218),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Uang Lunas / Tahap 3",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              Divider(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_data['proofThree'] != '') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ImagePay(
                                              urlImage: _data['proofThree'],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _data['proofOne'] == ''
                                          ? Image.asset(
                                              "assets/img/no-image.png",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              "${Config.urlStatic}/img-pay/${_data['proofThree']}",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _data['stepThree'] == 'yes'
                                          ? Text(
                                              "Sudah Dibayar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                              ),
                                            )
                                          : Text(
                                              "Belum Dibayar",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Rp. ${Hooks.formatHargaId(_data['jumlahUangLunas'])}",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}

class ImagePay extends StatelessWidget {
  final String urlImage;

  const ImagePay({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Image"),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(
            "${Config.urlStatic}/img-pay/${urlImage}",
          ),
        ),
      ),
    );
  }
}
