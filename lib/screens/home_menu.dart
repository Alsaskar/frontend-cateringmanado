import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:cateringmanado_new/screens/login.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  List<dynamic> _foods = [];

  Future<void> _fetchMenuTerbaik() async {
    final res = await FoodService().menuTerbaik(10);

    setState(() {
      _foods.addAll(res['result']);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMenuTerbaik();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            icon: Icon(
              Icons.login,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _foods.clear();
          });

          await _fetchMenuTerbaik();
        },
        child: ListView(
          children: [
            Container(
              color: Color(0xff1999fa),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Daftar menu yang tersedia",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menu Terbaik",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Makanan yang memiliki rating terbaik"),
                  Divider(),
                  _foods.length == 0 // jika data makanan belum ada
                      ? Text("Belum ada menu")
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

                            return Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Sebelah Kiri - Foto Makanan
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RatingStars(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              averageRating: averageRating,
                                              iconSize: 20,
                                            ),
                                            Text(
                                              'Rp ${Hooks.formatHargaId(item['harga'])}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.store),
                                            Text(
                                              "${item['admin_toko']['namaToko']}",
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
                            );
                          },
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
