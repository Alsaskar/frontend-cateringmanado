import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/dashboard_catering.dart';
import 'package:cateringmanado_new/screens/food/add_food.dart';
import 'package:cateringmanado_new/screens/food/detail_food.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:cateringmanado_new/widgets/RatingStars.dart';
import 'package:cateringmanado_new/widgets/SidebarCatering.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import 'package:intl/intl.dart';

class ListFood extends StatefulWidget {
  final String idUser;
  const ListFood({required this.idUser});

  @override
  State<ListFood> createState() => _ListFoodState();
}

class _ListFoodState extends State<ListFood> {
  ScrollController _scrollController = ScrollController();
  List<dynamic> _foods = [];
  int _page = 1;
  final int _limit = 8;
  bool _isLoading = false;
  bool _hasMore = true;
  var formatIndonesia = NumberFormat.decimalPattern('id');

  @override
  void initState() {
    super.initState();
    _fetchMoreFoods(widget.idUser);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchMoreFoods(widget.idUser);
      }
    });

    _checkShowAlert();
    _cekStatusCatering();
    SessionHelper.checkSesiLogin(context);
  }

  Future<void> _cekStatusCatering() async {
    var catering = await UserService.getProfilToko(widget.idUser);
    var user = await AuthService.getDataLoggedIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (catering['status'] == 'proses') {
      await prefs.setBool('showAlert', true);
      await prefs.setString(
          'message', "Akun Anda masih di proses jadi tidak bisa akses");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardCatering(
            fullname: "${user['firstname']} ${user['lastname']}",
            email: user['email'],
            idUser: user['id'],
          ),
        ),
      );
    } else if (catering['status'] == 'reject') {
      await prefs.setBool('showAlert', true);
      await prefs.setString(
          'message', "Akun Anda di tolak jadi tidak bisa akses");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardCatering(
            fullname: "${user['firstname']} ${user['lastname']}",
            email: user['email'],
            idUser: user['id'],
          ),
        ),
      );
    }
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
            title: 'Berhasil',
            message: messageAlert,
            color: Colors.green,
            txtBtn: 'OK',
          );
        },
      );

      await prefs.setBool('showAlert', false);
      await prefs.remove('message');
    }
  }

  Future<void> _fetchMoreFoods(idUser) async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var getDataToko =
          await UserService.getProfilToko(idUser); // ambil data catering
      final res = await FoodService()
          .listDataByToko(getDataToko['id'], '', _page, _limit);

      final List<dynamic> newFoods = res['result'];

      setState(() {
        _page++;
        _isLoading = false;
        _foods.addAll(newFoods);

        if (newFoods.length < _limit) {
          _hasMore = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.getDataLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!['loggedIn'] == false) {
            return Container();
          } else {
            Map<dynamic, dynamic>? user = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                title: Text("Data Makanan"),
              ),
              drawer: SidebarCatering(
                idUser: user!['id'],
                email: user['email'],
                fullname: "${user['firstname']} ${user['lastname']}",
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _foods.clear();
                    _page = 1;
                    _hasMore = true;
                  });

                  await _fetchMoreFoods(widget.idUser);
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Makanan",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text("Makanan yang ada pada Tempat Catering Anda"),
                            Button(
                              handleClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddFood(
                                      idUser: widget.idUser,
                                    ),
                                  ),
                                );
                              },
                              btnColor: Colors.blue,
                              text: "Tambah Makanan",
                              textColor: Colors.white,
                              height: 40,
                              width: 150,
                              margin: EdgeInsets.only(top: 5),
                              borderRadius: 5,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      _foods.length > 0
                          ? // bila sudah ada data
                          Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              height: MediaQuery.of(context).size.height / 2,
                              child: ListView.builder(
                                shrinkWrap: true,
                                controller: ScrollController(),
                                itemCount: _foods.length,
                                itemBuilder: (context, index) {
                                  var data = _foods[index];

                                  double averageRating = double.tryParse(
                                          data['averageRating'].toString()) ??
                                      0.0;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailFood(
                                            idMakanan: data['id'],
                                            idUser: widget.idUser,
                                            nama: data['nama'],
                                            harga: data['harga'],
                                            photo: data['photo'],
                                            tglInput: data['tglInput'],
                                            deskripsi: data['deskripsi'],
                                            averageRating: averageRating,
                                            ratingCount: data['ratingCount'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xff000000)
                                                .withOpacity(0.2),
                                            offset: Offset(0, 0),
                                            blurRadius: 2,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: data['photo'] == ''
                                                    ? Image.asset(
                                                        "assets/img/no-image.png",
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "${Config.urlStatic}/img-food/${data['photo']}",
                                                        width: 80,
                                                        height: 80,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${data['nama']}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  RatingStars(
                                                    averageRating:
                                                        averageRating,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    iconSize: 18,
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Rp. ${Hooks.formatHargaId(data['harga'])}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(width: 40),
                                                      Icon(
                                                        Icons.calendar_month,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        "${Hooks.formatDateTime(data['tglInput'])}",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ))
                          : // bila belum ada data

                          Column(
                              children: [
                                Text(
                                  "Belum ada Makanan pada Toko Anda. Silahkan Tambahkan",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
