import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/screens/pay/uang_lunas.dart';
import 'package:cateringmanado_new/screens/pay/uang_muka.dart';
import 'package:cateringmanado_new/screens/pay/uang_tengah.dart';
import 'package:cateringmanado_new/services/PayService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:flutter/material.dart';

class UserViewOrderItem extends StatefulWidget {
  final List<dynamic> item;
  final Map<dynamic, dynamic> adminToko;
  final String statusPembayaran;
  final String statusProses;
  final String idItemMaster;
  final String noInvoice;

  const UserViewOrderItem({
    required this.item,
    required this.adminToko,
    required this.statusPembayaran,
    required this.statusProses,
    required this.idItemMaster,
    required this.noInvoice,
  });

  @override
  State<UserViewOrderItem> createState() => _UserViewOrderItemState();
}

class _UserViewOrderItemState extends State<UserViewOrderItem> {
  int _grandTotal = 0;

  // hanya buktif tf uang muka dan uang tengah
  // untuk uang lunas tidak perlu di cek
  int _buktiTfUangMuka = 0;
  int _buktiTfUangTengah = 0;

  void _calculateGrandTotal() {
    setState(() {
      _grandTotal = widget.item.fold(0, (sum, item) {
        return sum + (item['hargaMakanan'] as int);
      });
    });
  }

  // cek status pembayaran
  Future<void> _cekStatus() async {
    var res =
        await PayService().cekStatus(widget.idItemMaster, widget.noInvoice);

    setState(() {
      _buktiTfUangMuka = res['stepOne'];
      _buktiTfUangTengah = res['stepTwo'];
    });
  }

  Future<void> _navigateToUangMuka() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UangMuka(
          noInvoice: widget.noInvoice,
          idItemMaster: widget.idItemMaster,
          grandTotal: _grandTotal,
          dataAdminToko: widget.adminToko,
        ),
      ),
    );

    _cekStatus();
  }

  Future<void> _navigateToUangTengah() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UangTengah(
          noInvoice: widget.noInvoice,
          idItemMaster: widget.idItemMaster,
          grandTotal: _grandTotal,
          dataAdminToko: widget.adminToko,
        ),
      ),
    );

    _cekStatus();
  }

  Future<void> _navigateToUangLunas() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UangLunas(
          noInvoice: widget.noInvoice,
          idItemMaster: widget.idItemMaster,
          grandTotal: _grandTotal,
          dataAdminToko: widget.adminToko,
        ),
      ),
    );

    _cekStatus();
  }

  @override
  void initState() {
    super.initState();
    _cekStatus();
    _calculateGrandTotal();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("List Item"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Data Item",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                "Makanan yang dipesan di ${widget.adminToko['fullname']}",
              ),
              Divider(),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                controller: ScrollController(),
                itemCount: widget.item.length,
                itemBuilder: (context, index) {
                  var data = widget.item[index];

                  return Container(
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
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: data['makanan']['photo'] == ''
                                  ? Image.asset(
                                      "assets/img/no-image.png",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "${Config.urlStatic}/img-food/${data['makanan']['photo']}",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data['namaMakanan']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Rp. ${Hooks.formatHargaId(data['hargaMakanan'])}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 15, 153, 252),
          height: MediaQuery.of(context).size.height / 4,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status Pembayaran : ${Hooks.capitalizeFirstLetter(widget.statusPembayaran)}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Status Order : ${widget.statusProses == 'proses' ? 'Menunggu Uang Muka' : Hooks.capitalizeFirstLetter(widget.statusProses)}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Item : ${widget.item.length}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "Grand Total : Rp. ${Hooks.formatHargaId(_grandTotal)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      handleClick: () {
                        _navigateToUangMuka();
                      },
                      btnColor: Colors.grey,
                      text: "Bayar DP",
                      textColor: Colors.white,
                      height: 40,
                      margin: EdgeInsets.all(0),
                      borderRadius: 50,
                    ),
                    Button(
                      handleClick: () {
                        // jika belum bayar uang muka belum bisa bayar uang tengah
                        if (_buktiTfUangMuka == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertMessage(
                                title: 'Opppss...',
                                message: 'Bayar Uang Muka atau DP dulu',
                                color: Colors.red,
                                txtBtn: 'OK',
                              );
                            },
                          );
                        } else {
                          _navigateToUangTengah();
                        }
                      },
                      btnColor: Colors.green,
                      text: "Uang Tengah",
                      textColor: Colors.white,
                      height: 40,
                      margin: EdgeInsets.all(0),
                      borderRadius: 50,
                    ),
                    Button(
                      handleClick: () {
                        // jika belum bayar uang tengah belum bisa bayar uang lunas
                        if (_buktiTfUangTengah == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertMessage(
                                title: 'Opppss...',
                                message: 'Bayar Uang Tengah Dulu',
                                color: Colors.red,
                                txtBtn: 'OK',
                              );
                            },
                          );
                        } else {
                          _navigateToUangLunas();
                        }
                      },
                      btnColor: Colors.white,
                      text: "Uang Lunas",
                      textColor: Colors.black,
                      height: 40,
                      margin: EdgeInsets.all(0),
                      borderRadius: 50,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
