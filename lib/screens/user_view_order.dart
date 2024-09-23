import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/helpers/OrderHelper.dart';
import 'package:cateringmanado_new/screens/main_dashboard.dart';
import 'package:cateringmanado_new/screens/user_view_order_item.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserViewOrder extends StatefulWidget {
  final String noInvoice;
  const UserViewOrder({required this.noInvoice});

  @override
  State<UserViewOrder> createState() => _UserViewOrderState();
}

class _UserViewOrderState extends State<UserViewOrder> {
  List<dynamic> _foods = [];

  Future<void> _fetchCart() async {
    var res = await OrderService().fetchDetailCart(widget.noInvoice);

    setState(() {
      _foods.addAll(res['result']);
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

  @override
  void initState() {
    super.initState();
    _fetchCart();
    _checkShowAlert();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var statusMaster = await OrderHelper().getStatusMaster();

        if (statusMaster == '0') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('statusMasterOrder', '1');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainDashboard(),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              var statusMaster = await OrderHelper().getStatusMaster();

              if (statusMaster == '0') {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('statusMasterOrder', '1');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainDashboard(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text("#${widget.noInvoice}"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Detail Orderan",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                "Orderan yang Anda order. Yang belum lunas silahkan lakukan pembayaran",
              ),
              Divider(),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _foods.length,
                itemBuilder: (context, index) {
                  var item = _foods[index];

                  print(item['catering']['user']);

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserViewOrderItem(
                            item: item['item_orders'],
                            adminToko: item['catering'],
                            statusPembayaran: item['prosesPembayaran'],
                            statusProses: item['statusProses'],
                            idItemMaster: item['id'],
                            noInvoice: item['noInvoice'],
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "#${item['noInvoice']}",
                                style: TextStyle(
                                  fontSize: 15,
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
                          Text(
                            "${item['catering']['fullname']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${Hooks.capitalizeFirstLetter(item['statusBayar'])}",
                                style: TextStyle(
                                  color: item['statusBayar'] == 'belum lunas'
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
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
