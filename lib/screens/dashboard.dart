import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/add_rating.dart';
import 'package:cateringmanado_new/screens/order/choose_toko.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> _foods = [];
  var formatIndonesia = NumberFormat.decimalPattern('id');
  TextEditingController _lokasi = TextEditingController();

  Future<void> _fetchMenuTerbaik() async {
    final res = await FoodService().menuTerbaik(10);

    setState(() {
      _foods.addAll(res['result']);
    });
  }

  Future<void> _nextStepOne(String alamatPengiriman) async {
    String _userId = await AuthHelper.getUserId();

    // bila user belum memasukkan alamat pengiriman
    if (alamatPengiriman == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertMessage(
            title: 'Opppsss...',
            message: 'Lokasi Pengiriman Masih Kosong',
            color: Colors.red,
            txtBtn: 'OK',
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseToko(
            alamatToko: alamatPengiriman,
            userId: _userId,
          ),
        ),
      );
    }
  }

  // Future<String> _getUserId() async {
  //   var userId = await AuthHelper.getUserId();
  //   return userId;
  // }

  @override
  void initState() {
    super.initState();

    _fetchMenuTerbaik();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AuthService.getDataLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!['loggedIn'] == false) {
            return Container();
          } else {
            Map<dynamic, dynamic>? user = snapshot.data;

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _foods.clear();
                });

                SessionHelper.checkSesiLogin(context);
                await _fetchMenuTerbaik();
              },
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        color: Color(0xff189cff),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 20,
                          right: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hai ${user!['firstname']} ${user['lastname']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Image.asset(
                              "assets/img/avatar-user.png",
                              height: 50,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 120,
                          left: 20,
                        ),
                        child: Text(
                          "Pesan Catering Sekarang",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 170, left: 20, right: 20),
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff000000).withOpacity(0.15),
                              offset: Offset(0, 0),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pilih Lokasi",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Kami akan antar pesanan Anda sesuai lokasi",
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _lokasi,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  prefixIcon: Icon(Icons.map),
                                  hintText: "Masukkan Lokasi",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xff1f9af7),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    _nextStepOne(_lokasi.text);
                                  },
                                  child: Text(
                                    "Pilih Tempat",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Menu Terbaik",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        _foods.length == 0 // jika data makanan belum ada
                            ? Center(
                                child: Text("Belum ada menu"),
                              )
                            : ListView.builder(
                                // jika sudah ada makanan
                                controller: ScrollController(),
                                shrinkWrap: true,
                                itemCount: _foods.length,
                                itemBuilder: (context, index) {
                                  var item = _foods[index];
                                  double averageRating = double.tryParse(
                                          item['averageRating'].toString()) ??
                                      0.0;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddRating(
                                            idMakanan: item['id'],
                                            namaMakanan: item['nama'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Sebelah Kiri - Foto Makanan
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: item['photo'] == ''
                                                ? Image.asset(
                                                    "assets/img/no-image.png",
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    "${Config.urlStatic}/img-food/${item['photo']}",
                                                    width: 90,
                                                    height: 90,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          SizedBox(width: 10),

                                          // Tengah - Deskripsi Makanan
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['nama'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RatingStars(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      averageRating:
                                                          averageRating,
                                                      iconSize: 20,
                                                    ),
                                                    Text(
                                                      'Rp ${Hooks.formatHargaId(item['harga'])}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Icon(Icons.store),
                                                    Text(
                                                      "${item['catering']['fullname']}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                  SizedBox(height: 10) // jarak di bagian bawah
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
