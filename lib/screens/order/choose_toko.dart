import 'package:cateringmanado_new/screens/order/step_one.dart';
import 'package:cateringmanado_new/services/TokoService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';

class ChooseToko extends StatefulWidget {
  final String alamatToko;
  final String userId;

  const ChooseToko({
    required this.alamatToko,
    required this.userId,
  });

  @override
  State<ChooseToko> createState() => _ChooseTokoState();
}

class _ChooseTokoState extends State<ChooseToko> {
  List<dynamic> _toko = [];

  Future<void> _listToko() async {
    final res = await TokoService().listToko(widget.alamatToko);

    setState(() {
      _toko.addAll(res['result']);
    });
  }

  @override
  void initState() {
    super.initState();

    _listToko();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Toko Catering"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Memilih Toko",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Silahkan pilih toko catering yang akan Anda pesan di dekat ${widget.alamatToko}",
            ),
            Divider(),
            _toko.length == 0
                ? // jika toko tidak ditemukan
                Text("Toko yang Anda cari tidak ditemukan")
                : ListView.builder(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: _toko.length,
                    itemBuilder: (context, index) {
                      var item = _toko[index];

                      return GestureDetector(
                        onTap: () {
                          // cek jika toko yang dipilih adalah toko sendiri, maka tidak bisa lanjut
                          if (item['userId'] == widget.userId) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertMessage(
                                  title: 'Oooppss...',
                                  message:
                                      "Tidak bisa masuk ke Toko Anda sendiri",
                                  color: Colors.red,
                                  txtBtn: 'OK',
                                );
                              },
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StepOne(
                                  alamatPengiriman: widget.alamatToko,
                                  userId: widget.userId,
                                  idAdminToko: item['id'],
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Sebelah Kiri - Foto Makanan
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  "assets/img/no-image.png",
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10),

                              // Tengah - Deskripsi Toko
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['fullname'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Icon(Icons.phone),
                                    //     Text(
                                    //       "${item['noHpToko']}",
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.map_sharp),
                                        Text(
                                          "${item['alamat']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
