import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/screens/user_view_order.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:cateringmanado_new/widgets/AlertConfirm.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:cateringmanado_new/widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepConfirm extends StatefulWidget {
  final String idUser;
  final String noInvoice;
  final int jumlahPesanan;
  final int totalHarga;

  const StepConfirm({
    required this.idUser,
    required this.noInvoice,
    required this.jumlahPesanan,
    required this.totalHarga,
  });

  @override
  State<StepConfirm> createState() => _StepConfirmState();
}

class _StepConfirmState extends State<StepConfirm> {
  void _showItemDetailModal(BuildContext context, dynamic itemData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Ukuran awal modal. (0.6 = 60% dari layar)
          minChildSize: 0.2, // Ukuran minimum modal (0.2 = 20% dari layar)
          maxChildSize: 0.9, // Ukuran maksimum modal (0.9 = 90% dari layar)
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 8),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Detail Order",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Divider(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      children: [
                        Text(
                          "Item atau Makanan yang Anda Pesan di ${itemData['catering']['fullname']}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          controller: ScrollController(),
                          shrinkWrap: true,
                          itemCount: itemData['item_orders'].length,
                          itemBuilder: (context, index) {
                            var item = itemData['item_orders'][index];
                            double averageRating = double.tryParse(
                                    item['makanan']['averageRating']
                                        .toString()) ??
                                0.0;

                            return Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Sebelah Kiri - Foto Makanan
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: item['makanan']['photo'] == ''
                                        ? Image.asset(
                                            "assets/img/no-image.png",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "${Config.urlStatic}/img-food/${item['makanan']['photo']}",
                                            width: 50,
                                            height: 50,
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
                                          item['makanan']['nama'],
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
                                              'Rp ${Hooks.formatHargaId(item['makanan']['harga'])}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _order() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertConfirm(
          title: "Konfirmasi Pesanan",
          message: "Yakin sudah benar?",
          clickKanan: () {
            Navigator.pop(context);
          },
          clickKiri: () async {
            try {
              var res = await OrderService().confirmOrder(
                widget.noInvoice,
                {
                  'jumlahItem': widget.jumlahPesanan.toString(),
                  'grandTotal': widget.totalHarga.toString(),
                },
              );

              if (res['success']) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('showAlert', true);
                await prefs.setString('message', '${res['message']}');

                // set untuk user view order, agar tidak bisa
                // kembali ke halaman ini ketika sudah order
                // 0 = sudah di order, tidak bisa kesini lagi
                await prefs.setString('statusMasterOrder', '0');

                Navigator.of(context).pop(); // close dialog

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserViewOrder(
                      noInvoice: widget.noInvoice,
                    ),
                  ),
                );
              }
            } catch (err) {
              print(err);
            }
          },
          textKiri: "Ya",
          textKanan: "Tidak",
          colorTextKiri: Colors.white,
          colorTextKanan: Colors.blue,
          btnStyleKiri: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.green,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: FutureBuilder(
          future: OrderService().detailMaster(widget.noInvoice, widget.idUser),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data!['loggedIn'] == false) {
              return Container();
            } else {
              Map<dynamic, dynamic>? masterOrder = snapshot.data!['result'][0];
              List<dynamic> masterItem = masterOrder!['item_masters'];

              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 46, 119, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.receipt, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "#${masterOrder['noInvoice']}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.event, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "${Hooks.formatDateTime(
                                    masterOrder['tglInvoice'],
                                  )}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "Lokasi Pengiriman",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "${masterOrder['alamatPengiriman']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Orderan Anda",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Tekan pada Toko untuk lihat item apa saja yang Anda pesan",
                        ),
                        SizedBox(height: 10),

                        // List Master Item
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 1.6,
                          child: ListView.builder(
                            itemCount: masterItem.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    _showItemDetailModal(
                                        context, masterItem[index]);
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${masterItem[index]['catering']['fullname']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // Text(
                                          //   "${masterItem[index]['admin_toko']['emailToko']}",
                                          //   style: TextStyle(
                                          //     color: Colors.grey,
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${Hooks.formatDateTime(masterItem[index]['tglOrder'])}",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            "${masterItem[index]['item_orders'].length} Items",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff29a3ff),
        height: MediaQuery.of(context).size.height / 3,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Konfirmasi Pesanan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Silahkan lihat orderan Anda, bila benar silahkan pesan",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Divider(),
              Text(
                "Jumlah Pesanan : ${widget.jumlahPesanan}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 3),
              Text(
                "Total Harga : Rp ${Hooks.formatHargaId(widget.totalHarga)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Button(
                    handleClick: _order,
                    btnColor: Colors.green,
                    text: "Pesan",
                    textColor: Colors.white,
                    height: 40,
                    width: 150,
                    margin: EdgeInsets.all(0),
                    borderRadius: 5,
                  ),

                  // jarak btn lanjut dan btn cancel
                  SizedBox(width: 10),

                  Button(
                    handleClick: () {
                      Navigator.of(context).pop();
                    },
                    btnColor: Colors.red,
                    text: "Kembali",
                    textColor: Colors.white,
                    height: 40,
                    width: 150,
                    margin: EdgeInsets.all(0),
                    borderRadius: 5,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
