import 'package:cateringmanado_new/screens/profil_catering.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:cateringmanado_new/widgets/SidebarCatering.dart';
import 'package:flutter/material.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardCatering extends StatefulWidget {
  final String fullname;
  final String idUser;
  final String email;

  const DashboardCatering({
    required this.fullname,
    required this.idUser,
    required this.email,
  });

  @override
  State<DashboardCatering> createState() => _DashboardCateringState();
}

class _DashboardCateringState extends State<DashboardCatering> {
  int _totalSemuaMakanan = 0;
  int _totalSemuaOrder = 0;

  @override
  void initState() {
    super.initState();

    _checkShowAlert();
    _totalMakanan();
    _totalOrder();
    SessionHelper.checkSesiLogin(context);
  }

  Future<void> _totalMakanan() async {
    var _toko = await UserService.getProfilToko(widget.idUser);
    var totalMakanan = await FoodService().total(_toko['id']);

    setState(() {
      _totalSemuaMakanan = totalMakanan;
    });
  }

  Future<void> _totalOrder() async {
    var _toko = await UserService.getProfilToko(widget.idUser);
    var totalOrder = await OrderService().total(_toko['id']);

    setState(() {
      _totalSemuaOrder = totalOrder;
    });
  }

  Future<void> _checkShowAlert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showAlert = prefs.getBool('showAlert') ?? false;
    String messageAlert = prefs.getString('message') ?? '';

    if (showAlert) {
      setState(() {});

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertMessage(
            title: 'Oppsss...',
            message: messageAlert,
            color: Colors.red,
            txtBtn: 'OK',
          );
        },
      );

      await prefs.setBool('showAlert', false);
      await prefs.remove('message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard Catering"),
        ),
        drawer: SidebarCatering(
          fullname: widget.fullname,
          email: widget.email,
          idUser: widget.idUser,
        ),
        body: FutureBuilder(
          future: UserService.getProfilToko(widget.idUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data!['loggedIn'] == false) {
              return Container();
            } else {
              Map<dynamic, dynamic>? data = snapshot.data;

              if (data!['status'] == 'proses') {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Mohon menunggu. Catering Anda sedang diproses oleh Admin untuk disetujui",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Lengkapi Profil | Data Rekening",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Segera dilengkapi karena Admin akan melihat profil Anda secara lengkap. Jika tidak lengkap, maka akan ditolak",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Cara Lengkapi Profil : Tekan Tombol Dibawah ini, setelah itu pergi ke Menu Ubah Informasi. Lalu scroll ke bagian bawah di bagian Data Rekening",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 10),
                      Button(
                        handleClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilCatering(),
                            ),
                          );
                        },
                        btnColor: Colors.blue,
                        text: "Lengkapi Sekarang",
                        textColor: Colors.white,
                        height: 40,
                        width: 150,
                        margin: EdgeInsets.only(top: 5),
                        borderRadius: 5,
                      ),
                    ],
                  ),
                );
              } else if (data['status'] == 'approve') {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hai ${data['fullname']}",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Anda Login Sebagai Catering",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Icon(
                              Icons.fastfood_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Total Makanan",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${_totalSemuaMakanan}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              size: 80,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Total Pesanan",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${_totalSemuaOrder}",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 148, 159, 168),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hai ${data['fullname']}",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Anda Login Sebagai Catering",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Akun Anda Ditolak. Dengan Alasan : ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.red,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${data['ketTolak']}",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
