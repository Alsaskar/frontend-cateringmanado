import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/screens/dashboard_catering.dart';
import 'package:cateringmanado_new/screens/order/view_by_toko.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:cateringmanado_new/services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOrderByToko extends StatefulWidget {
  final String idUser;

  const ListOrderByToko({required this.idUser});

  @override
  State<ListOrderByToko> createState() => _ListOrderByTokoState();
}

class _ListOrderByTokoState extends State<ListOrderByToko> {
  List<dynamic> _foods = [];
  int _page = 1;
  bool _isLoading = false;
  final int _limit = 10;
  int _totalPages = 1;
  int _grandTotal = 0;

  TextEditingController _search = TextEditingController();

  Future<void> _listOrderCustomer({bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      setState(() {
        _foods = [];
        _page = 1;
        _totalPages = 1;
      });
    }

    if (_page > _totalPages) return;

    setState(() {
      _isLoading = true;
    });

    var getDataToko = await UserService.getProfilToko(widget.idUser);

    var res = await OrderService().listOrderCustomer(
      getDataToko['id'],
      _search.text,
      _page,
      _limit,
    );

    final List<dynamic> newFoods = res['result'];

    setState(() {
      _foods.addAll(newFoods);
      _totalPages = res['totalPage'];
      _page++;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _listOrderCustomer();
    _cekStatusCatering();
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
          'message', "Akun Anda masih di tolak jadi tidak bisa akses");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Pesanan"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _listOrderCustomer(reset: true);
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pesanan Customer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Pesanan yang masuk",
              ),
              Divider(),
              SizedBox(height: 10),
              TextField(
                controller: _search,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  hintText: "Cari No Invoice",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _listOrderCustomer(reset: true);
                    },
                    icon: Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !_isLoading) {
                      _listOrderCustomer();
                    }

                    return true;
                  },
                  child: _foods.length > 0 // jika sudah ada pesanan
                      ? ListView.builder(
                          itemCount: _foods.length,
                          itemBuilder: (context, index) {
                            if (index == _foods.length) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : SizedBox.shrink(),
                                ),
                              );
                            }

                            var item = _foods[index];
                            _grandTotal =
                                item['item_orders'].fold(0, (sum, item) {
                              return sum + (item['hargaMakanan'] as int);
                            });

                            return GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewOrderByToko(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff000000).withOpacity(0.2),
                                      offset: Offset(0, 0),
                                      blurRadius: 2,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    item['statusCekNotif'] ==
                                            'no' // jika notif belum dilihat
                                        ? Container(
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "New",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            width: 80,
                                          )
                                        : SizedBox(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "#${item['noInvoice']}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${Hooks.formatDateTime(item['tglOrder'])}",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Pembeli :",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "${item['user']['firstname']} ${item['user']['lastname']}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Item :",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "${item['item_orders'].length}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Grand Total :",
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          "Rp. ${Hooks.formatHargaId(_grandTotal)}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${Hooks.capitalizeFirstLetter(item['statusBayar'])}",
                                          style: TextStyle(
                                            color: item['statusBayar'] ==
                                                    'belum lunas'
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        Text(
                                          "${Hooks.capitalizeFirstLetter(item['statusProses'])}",
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : // jika belum ada pesanan

                      Text(
                          "Belum memiliki pesanan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
