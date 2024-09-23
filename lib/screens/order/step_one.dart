import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/helpers/OrderHelper.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/order/step_confirm.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
// import 'package:cateringmanado_new/services/UserService.dart';
import 'package:cateringmanado_new/widgets/AlertButton.dart';
import 'package:cateringmanado_new/widgets/AlertConfirm.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:cateringmanado_new/widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cateringmanado_new/services/OrderService.dart';

class StepOne extends StatefulWidget {
  final String alamatPengiriman;
  final String userId;
  final String idAdminToko;

  const StepOne({
    required this.alamatPengiriman,
    required this.userId,
    required this.idAdminToko,
  });

  @override
  State<StepOne> createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  List _foods = [];
  int _page = 1;
  bool _isLoading = false;
  final int _limit = 10;
  int _totalPages = 1;
  TextEditingController _search = TextEditingController();
  var formatIndonesia = NumberFormat.decimalPattern('id');

  int _jumlahPesanan = 0; // total pesanan
  int _totalHarga = 0; // total harga

  Future<void> _fetchFoods({bool reset = false}) async {
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

    // data = mengambil data admin toko
    // final Map<dynamic, dynamic> data =
    //     await UserService.getProfilToko(widget.userId);

    print(widget.idAdminToko);

    var res = await FoodService()
        .listOrder(widget.idAdminToko, _search.text, _page, _limit);

    final List<dynamic> newFoods = res['result'];

    setState(() {
      _foods.addAll(newFoods);
      _totalPages = res['totalPage'];
      _page++;
      _isLoading = false;
    });
  }

  Future<void> order(String idAdminToko, String idMakanan, String namaMakanan,
      int hargaMakanan, int jumlah) async {
    String idUser = await AuthHelper.getUserId();
    String noInvoice = await OrderHelper().getNoInvoice();

    try {
      var res = await OrderService().add({
        'idUser': idUser,
        'noInvoice': noInvoice,
        'alamatPengiriman': widget.alamatPengiriman,
        'idAdminToko': idAdminToko,
        'idMakanan': idMakanan,
        'namaMakanan': namaMakanan,
        'hargaMakanan': hargaMakanan.toString(),
      });

      if (res['success']) {
        setState(() {
          _jumlahPesanan += jumlah;
          _totalHarga += hargaMakanan * jumlah;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertMessage(
              title: 'Opppsss...',
              message: res['message'],
              color: Colors.red,
              txtBtn: 'OK',
            );
          },
        );
      }
    } catch (err) {
      print(err);
    }
  }

  // hapus atau mengurangi item
  Future<void> _deleteItem(String idAdminToko, String idMakanan,
      int hargaMakanan, int jumlah) async {
    String noInvoice = await OrderHelper().getNoInvoice();

    try {
      var res = await OrderService().deleteItem({
        'noInvoice': noInvoice,
        'idMakanan': idMakanan,
        'idAdminToko': idAdminToko,
      });

      if (res['success']) {
        setState(() {
          _jumlahPesanan -= jumlah;
          _totalHarga -= hargaMakanan * jumlah;
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertMessage(
              title: 'Opppsss...',
              message: res['message'],
              color: Colors.red,
              txtBtn: 'OK',
            );
          },
        );
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _cancel() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertConfirm(
          title: "Orderan Anda Akan Dibatalkan",
          message: "Yakin Ingin Dibatalkan?",
          clickKiri: () {
            Navigator.pop(context);
          },
          clickKanan: () async {
            String noInvoice = await OrderHelper().getNoInvoice();
            try {
              var res = await OrderService().cancel(
                noInvoice,
                {'status': 'batal'},
              );

              if (res['success']) {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // kembali ke dashboard
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertMessage(
                      title: 'Opppsss...',
                      message: res['message'],
                      color: Colors.red,
                      txtBtn: 'OK',
                    );
                  },
                );
              }
            } catch (err) {
              print(err);
            }
          },
          textKiri: "Tidak",
          textKanan: "Ya",
          colorTextKiri: Colors.white,
          colorTextKanan: Colors.blue,
          btnStyleKiri: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.red,
            ),
          ),
        );
      },
    );
  }

  // cek status master order
  // bila orderan sebelumnya masih proses, tidak bisa order yg baru
  Future<void> _cekStatusMaster() async {
    try {
      var res = await OrderService().cekStatusMaster(widget.userId);

      if (res['success']) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertButton(
              title: 'Opppsss...',
              message: res['message'],
              color: Colors.red,
              txtBtn: 'OK',
              handleClick: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // kembali ke dashboard
              },
            );
          },
        );
      }
    } catch (err) {
      print(err);
    }
  }

  // lanjut ke step berikut, yaitu lakukan konfirmasi order
  Future<void> _nextConfirm() async {
    String noInvoice = await OrderHelper().getNoInvoice();
    print("Nomor Invoice : ${noInvoice}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepConfirm(
          idUser: widget.userId,
          noInvoice: noInvoice,
          jumlahPesanan: _jumlahPesanan,
          totalHarga: _totalHarga,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchFoods();
    _cekStatusMaster();
    SessionHelper.checkSesiLogin(context);
    OrderHelper().setNoInvoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchFoods(reset: true);
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 55,
                  bottom: 10,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
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
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Lokasi Pengiriman",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${widget.alamatPengiriman}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 3),
                    Image.asset(
                      "assets/img/delivery.png",
                      height: 100,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, left: 10, right: 10),
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    hintText: "Cari Makanan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _fetchFoods(reset: true);
                      },
                      icon: Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
                        !_isLoading) {
                      _fetchFoods();
                    }

                    return true;
                  },
                  child: ListView.builder(
                    itemCount: _foods.length,
                    itemBuilder: (context, index) {
                      double averageRating = double.tryParse(
                              _foods[index]['averageRating'].toString()) ??
                          0.0;

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

                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Sebelah Kiri - Foto Makanan
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _foods[index]['photo'] == ''
                                  ? Image.asset(
                                      "assets/img/no-image.png",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      "${Config.urlStatic}/img-food/${_foods[index]['photo']}",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(width: 10),

                            // Tengah - Deskripsi Makanan
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _foods[index]['nama'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RatingStars(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    averageRating: averageRating,
                                    iconSize: 20,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        'Rp ${formatIndonesia.format(_foods[index]['harga']).toString()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Kanan - Tombol Plus (+) & Tombol Minus (-)
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    order(
                                      _foods[index]['catering']['id'],
                                      _foods[index]['id'],
                                      _foods[index]['nama'],
                                      _foods[index]['harga'],
                                      1,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    _deleteItem(
                                      _foods[index]['catering']['id'],
                                      _foods[index]['id'],
                                      _foods[index]['harga'],
                                      1,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff29a3ff),
        height: MediaQuery.of(context).size.height / 4.5,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jumlah Pesanan : $_jumlahPesanan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Total Harga : Rp ${formatIndonesia.format(_totalHarga)}",
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
                  // bila jumlah pesanan sudah ada, bisa lanjut
                  _jumlahPesanan > 0
                      ? Button(
                          handleClick: () {
                            _nextConfirm();
                          },
                          btnColor: Colors.white,
                          text: "Lanjut",
                          textColor: Colors.black,
                          height: 40,
                          width: 150,
                          margin: EdgeInsets.all(0),
                          borderRadius: 5,
                        )
                      : // bila jumlah pesanan masih 0, belum bisa lanjut
                      Button(
                          handleClick: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertMessage(
                                  title: 'Anda Belum Bisa Lanjut',
                                  message: 'Anda belum memilih makanan',
                                  color: Colors.red,
                                  txtBtn: 'OK',
                                );
                              },
                            );
                          },
                          btnColor: Colors.white,
                          text: "Lanjut",
                          textColor: Colors.black,
                          height: 40,
                          width: 150,
                          margin: EdgeInsets.all(0),
                          borderRadius: 5,
                        ),

                  // jarak btn lanjut dan btn cancel
                  SizedBox(width: 10),

                  Button(
                    handleClick: _cancel,
                    btnColor: Colors.red,
                    text: "Batalkan",
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
