import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/Hooks.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';
import 'package:cateringmanado_new/screens/food/edit_food.dart';
import 'package:cateringmanado_new/screens/food/list_food.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/widgets/AlertConfirm.dart';
import 'package:cateringmanado_new/widgets/Button.dart';
import 'package:cateringmanado_new/widgets/RatingStars.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DetailFood extends StatefulWidget {
  final String idMakanan;
  final String nama;
  final int harga;
  final String photo;
  final String tglInput;
  final String deskripsi;
  final double averageRating;
  final int ratingCount;
  final String idUser;

  const DetailFood({
    required this.idMakanan,
    required this.nama,
    required this.harga,
    required this.photo,
    required this.tglInput,
    required this.deskripsi,
    required this.averageRating,
    required this.ratingCount,
    required this.idUser,
  });

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  var formatIndonesia = NumberFormat.decimalPattern('id');

  Future<void> _deleteData() async {
    try {
      var res = await FoodService().deleteData(widget.idMakanan);

      if (res['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('showAlert', true);
        await prefs.setString('message', res['message']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListFood(
              idUser: widget.idUser,
            ),
          ),
        );
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail ${widget.nama}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.photo == ''
                ? Image.asset(
                    "assets/img/no-image.png",
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    '${Config.urlStatic}/img-food/${widget.photo}',
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                  ),
            Divider(),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.nama}",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp. ${Hooks.formatHargaId(widget.harga)}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "${Hooks.formatDateTime(widget.tglInput)}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 5),

                  // rating
                  RatingStars(
                    mainAxisAlignment: MainAxisAlignment.start,
                    averageRating: widget.averageRating,
                  ),

                  SizedBox(height: 20),
                  widget.deskripsi == ''
                      ? Text("Tidak ada deskripsi")
                      : Text("${widget.deskripsi}"),

                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Button(
                        handleClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFood(
                                id: widget.idMakanan,
                                nama: widget.nama,
                                harga: widget.harga,
                                deskripsi: widget.deskripsi,
                                idUser: widget.idUser,
                              ),
                            ),
                          );
                        },
                        btnColor: Colors.blue,
                        width: 150,
                        text: "Edit",
                        textColor: Colors.white,
                        height: 40,
                        margin: EdgeInsets.all(10),
                        borderRadius: 5,
                      ),
                      Button(
                        handleClick: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertConfirm(
                                title: 'Konfirmasi',
                                message: 'Yakin ingin hapus makanan ini?',
                                clickKiri: () {
                                  Navigator.of(context).pop();
                                },
                                clickKanan: () {
                                  _deleteData();
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
                        },
                        btnColor: Colors.red,
                        text: "Hapus",
                        textColor: Colors.white,
                        width: 150,
                        height: 40,
                        margin: EdgeInsets.all(10),
                        borderRadius: 5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
