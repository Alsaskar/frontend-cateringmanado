import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/user_view_order.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:flutter/material.dart';

class CartOrder extends StatefulWidget {
  const CartOrder({super.key});

  @override
  State<CartOrder> createState() => _CartOrderState();
}

class _CartOrderState extends State<CartOrder> {
  List<dynamic> _foods = [];

  Future<void> _fetchCart() async {
    var idUser = await AuthHelper.getUserId();
    var res = await OrderService().fetchCart(idUser);

    // jika token belum expired, datanya muncul
    if (res['loggedIn'] != false) {
      setState(() {
        _foods.addAll(res['result']);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchCart();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(
            "Data Order",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Orderan yang telah Anda Pesan",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          _foods.isEmpty
              ? Center(
                  child: Text("Anda belum memiliki orderan"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  controller: ScrollController(),
                  itemCount: _foods.length,
                  itemBuilder: (context, index) {
                    var item = _foods[index];

                    return GestureDetector(
                      onTap: () async {
                        // var noInvoice = await OrderHelper().getNoInvoice();
                        // var idUser = await AuthHelper.getUserId();

                        if (item['status'] == 'proses') {
                          print("restore order");
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserViewOrder(
                                noInvoice: item['noInvoice'],
                              ),
                            ),
                          );
                        }
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    "${Hooks.formatDateTime(item['tglInvoice'])}")
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${item['alamatPengiriman']}",
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Total Item : ${item['jumlahItem']}"),
                                    SizedBox(height: 5),
                                    Text(
                                      "Grand Total : Rp. ${Hooks.formatHargaId(item['grandTotal'])}",
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(),
                            item['status'] == 'order'
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.check, color: Colors.green),
                                      SizedBox(width: 2),
                                      Text("Di Order"),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.dangerous, color: Colors.red),
                                      SizedBox(width: 2),
                                      Text("Orderan Belum Selesai"),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
