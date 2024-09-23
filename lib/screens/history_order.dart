import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/user_view_order.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:cateringmanado_new/widgets/AlertConfirm.dart';
import 'package:flutter/material.dart';

class HistoryOrder extends StatefulWidget {
  const HistoryOrder({super.key});

  @override
  State<HistoryOrder> createState() => _HistoryOrderState();
}

class _HistoryOrderState extends State<HistoryOrder> {
  List<dynamic> _orders = [];

  Future<void> _listHistory() async {
    var idUser = await AuthHelper.getUserId();
    var res = await OrderService().listHistory(idUser);

    setState(() {
      _orders = res['result'];
    });
  }

  Future<void> _deleteData(String noInvoice) async {
    var res = await OrderService().deleteData(noInvoice);

    if (res['success']) {
      Navigator.of(context).pop(); // close modal

      _listHistory();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${res['message']}',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _listHistory();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _listHistory,
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "History",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "History orderan yang Anda pesan. Silahkan hapus orderan yang Anda batalkan atau yang masih di proses",
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            Divider(),
            _orders.isEmpty
                ? Center(
                    child: Text("Anda belum ada orderan"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      var item = _orders[index];

                      return GestureDetector(
                        onTap: () async {
                          if (item['status'] == 'proses' ||
                              item['status'] == 'batal') {
                            showDialog(
                              context: context,
                              builder: (
                                BuildContext context,
                              ) {
                                return AlertConfirm(
                                  title: 'Hapus Order',
                                  message:
                                      'Anda akan menghapus orderan dan datanya tidak akan kembali lagi. Yakin?',
                                  clickKiri: () {
                                    Navigator.of(context).pop();
                                  },
                                  clickKanan: () {
                                    _deleteData(item['noInvoice']);
                                  },
                                  textKiri: 'Tidak',
                                  textKanan: 'Ya',
                                  btnStyleKiri: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.red,
                                    ),
                                  ),
                                  colorTextKiri: Colors.white,
                                  colorTextKanan: Colors.blue,
                                );
                              },
                            );
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
                                      Text(
                                          "Total Item : ${item['jumlahItem']}"),
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
                                  : item['status'] == 'batal'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.dangerous,
                                                color: Colors.red),
                                            SizedBox(width: 2),
                                            Text("Dibatalkan"),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.dangerous,
                                                color: Colors.red),
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
      ),
    );
  }
}
