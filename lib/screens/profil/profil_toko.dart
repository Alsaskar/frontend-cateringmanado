import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:flutter/material.dart';

class ProfilToko extends StatefulWidget {
  final String idUser;
  const ProfilToko({required this.idUser});

  @override
  State<ProfilToko> createState() => _ProfilTokoState();
}

class _ProfilTokoState extends State<ProfilToko> {
  @override
  void initState() {
    super.initState();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: UserService.getProfilToko(widget.idUser),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            Map<dynamic, dynamic>? profilToko = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                    color: Colors.blue,
                    height: 200,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            "assets/img/user-toko.png",
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profilToko['namaToko'],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              profilToko['emailToko'],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => AddFood(
                        //       idAdminToko: profilToko['id'],
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xff34a6fc),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fastfood,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(width: 20),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Tambah Makanan",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Silahkan tambahkan makanan baru",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ListFood(
                        //       idAdminToko: profilToko['id'],
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xff69b3ec),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(width: 20),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Data Makanan",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Makanan yang telah ditambahkan",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => ListOrderByToko(
                        //       idAdminToko: profilToko['id'],
                        //     ),
                        //   ),
                        // );
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xff34a6fc),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fastfood,
                              size: 50,
                              color: Colors.white,
                            ),
                            SizedBox(width: 20),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  Text(
                                    "Pesanan",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Lihat Pesanan yang dipesan customer",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
