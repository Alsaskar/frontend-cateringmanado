import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/services/FoodService.dart';
import 'package:cateringmanado_new/widgets/AlertMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddRating extends StatefulWidget {
  final String idMakanan;
  final String namaMakanan;

  const AddRating({
    required this.idMakanan,
    required this.namaMakanan,
  });

  @override
  State<AddRating> createState() => _AddRatingState();
}

class _AddRatingState extends State<AddRating> {
  double _rating = 0.0;
  bool _isLoading = false;

  Future<void> _submitRating() async {
    Future.delayed(Duration(seconds: 2), () async {
      try {
        var idUser = await AuthHelper.getUserId();

        if (_rating == 0.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertMessage(
                title: 'Gagal...',
                message: 'Anda belum mengisi rating',
                color: Colors.red,
                txtBtn: 'OK',
              );
            },
          );

          setState(() {
            _isLoading = false;
          });
        } else {
          var res =
              await FoodService().addRating(idUser, widget.idMakanan, _rating);

          if (res['success']) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertMessage(
                  title: 'Berhasil',
                  message: res['message'],
                  color: Colors.green,
                  txtBtn: 'OK',
                );
              },
            );

            setState(() {
              _isLoading = false;
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertMessage(
                  title: 'Gagal...',
                  message: res['message'],
                  color: Colors.red,
                  txtBtn: 'OK',
                );
              },
            );

            setState(() {
              _isLoading = false;
            });
          }
        }
      } catch (err) {
        print(err);

        setState(() {
          _isLoading = false;
        });
      }
    });

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Beri Rating"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Beri Rating",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Text(
              "Silahkan beri rating pada ${widget.namaMakanan}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Your Rating: $_rating',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? ElevatedButton(
                    onPressed: null,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      _submitRating();
                    },
                    child: Text('Kirim Rating'),
                  ),
          ],
        ),
      ),
    );
  }
}
