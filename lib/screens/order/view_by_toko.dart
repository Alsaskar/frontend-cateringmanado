import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/screens/pay/view_check.dart';
import 'package:cateringmanado_new/services/OrderService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:flutter/material.dart';

class ViewOrderByToko extends StatefulWidget {
  final Map<dynamic, dynamic> item;
  const ViewOrderByToko({required this.item});

  @override
  State<ViewOrderByToko> createState() => _ViewOrderByTokoState();
}

class _ViewOrderByTokoState extends State<ViewOrderByToko> {
  int _grandTotal = 0;
  List<dynamic> _items = [];
  String? _selectedStatus = '...';
  bool _isLoading = false;

  List<String> _listStatus = [
    "...",
    "Memasak",
    "Packing",
    "Diantar",
    "Tiba",
  ];

  Future<void> _listItem() async {
    var res = await OrderService().listItemCustomer(widget.item['id']);

    setState(() {
      _items.addAll(res['result']);
    });
  }

  Future<void> _updateStatusCekNotif() async {
    try {
      await OrderService().updateStatusCekNotif(widget.item['id'], 'yes');
    } catch (err) {
      print(err);
    }
  }

  // show modal ubah status
  void _showUbahStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (
        BuildContext context,
      ) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize:
                  0.5, // Ukuran awal modal. (0.6 = 60% dari layar)
              minChildSize: 0.2, // Ukuran minimum modal (0.2 = 20% dari layar)
              maxChildSize: 0.9, // Ukuran maksimum modal (0.9 = 90% dari layar)
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          height: 4,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ubah Status",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Text("Ubah Status Order"),
                            Divider(),
                            InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: Icon(Icons.more_horiz),
                                  value: _selectedStatus,
                                  hint: Text('Pilih Status'),
                                  isExpanded: true,
                                  items: _listStatus.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value == '...'
                                          ? 'Pilih Status'
                                          : value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setModalState(() {
                                      _selectedStatus = newValue;
                                    });
                                    setState(() {
                                      _selectedStatus = newValue;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Button(
                              handleClick: () {
                                Future.delayed(Duration(seconds: 2), () async {
                                  try {
                                    var res = await OrderService().updateStatus(
                                      widget.item['id'],
                                      widget.item['noInvoice'],
                                      _selectedStatus!,
                                    );

                                    if (res['success']) {
                                      Navigator.pop(context); // close modal

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertMessage(
                                            title: "Berhasil",
                                            message: res['message'],
                                            color: Colors.green,
                                            txtBtn: 'OK',
                                          );
                                        },
                                      );

                                      setModalState(() {
                                        _isLoading = false;
                                      });

                                      setState(() {
                                        widget.item['statusProses'] =
                                            _selectedStatus;
                                      });
                                    } else {
                                      setModalState(() {
                                        _isLoading = false;
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertMessage(
                                            title: "Gagal",
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
                                });

                                setModalState(() {
                                  _isLoading = true;
                                });
                              },
                              btnColor: Colors.blue,
                              text: _isLoading
                                  ? "Loading..."
                                  : "Simpan Perubahan",
                              textColor: Colors.white,
                              height: 50,
                              width: double.infinity,
                              margin: EdgeInsets.all(20),
                              borderRadius: 50,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _listItem();

    if (widget.item['statusCekNotif'] == 'no') {
      _updateStatusCekNotif();
    }

    setState(() {
      _grandTotal = widget.item['item_orders'].fold(0, (sum, item) {
        return sum + (item['hargaMakanan'] as int);
      });

      if (widget.item['statusProses'] != 'Proses') {
        _selectedStatus = widget.item['statusProses'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#${widget.item['noInvoice']}"),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff000000).withOpacity(0.5),
                    offset: Offset(0, 0),
                    blurRadius: 3,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${widget.item['noInvoice']}",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      SizedBox(width: 2),
                      Text(
                        "${widget.item['user']['firstname']} ${widget.item['user']['lastname']}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tanggal Order : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "${Hooks.formatDateTime(widget.item['tglOrder'])}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${Hooks.capitalizeFirstLetter(widget.item['statusBayar'])}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      widget.item['prosesPembayaran'] == 'lunas'
                          ? Text(
                              "Lunas",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )
                          : Text(
                              "Menunggu ${Hooks.capitalizeFirstLetter(widget.item['prosesPembayaran'])}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Status : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "${Hooks.capitalizeFirstLetter(widget.item['statusProses'])}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Item : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "${Hooks.capitalizeFirstLetter(
                          widget.item['item_orders'].length.toString(),
                        )}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total : ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Rp. ${Hooks.formatHargaId(_grandTotal)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "List Item",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  var data = _items[index];
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
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
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewCheckPembayaran(
                  idItemMaster: widget.item['id'],
                ),
              ),
            );
          } else if (index == 1) {
            _showUbahStatus(context);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Cek Pembayaran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Ubah Status Order',
          ),
        ],
      ),
    );
  }
}
