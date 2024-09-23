import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double averageRating;
  final MainAxisAlignment mainAxisAlignment;
  final double iconSize;

  const RatingStars({
    required this.averageRating,
    required this.mainAxisAlignment,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    // konversi nilai rata2 rating menjadi jumlah bintang yang akan ditampilkan
    int numberOfStars = averageRating.floor();
    List<Widget> starWidgets = [];

    // tambahkan bintang penuh sebanyak nilai rata2
    for (int i = 0; i < numberOfStars; i++) {
      starWidgets.add(
        Icon(
          Icons.star,
          color: Colors.amber,
          size: iconSize,
        ),
      );
    }

    // jika nilai rata2 memiliki pecahan, tambahkan bintang setengah
    if (averageRating - numberOfStars >= 0.5) {
      starWidgets.add(
        Icon(
          Icons.star_half,
          color: Colors.amber,
        ),
      );

      numberOfStars++;
    }

    // tambahkan bintang kosong untuk melengkapi total 5 bintang
    while (starWidgets.length < 5) {
      starWidgets.add(
        Icon(
          Icons.star_border,
          color: Colors.amber,
          size: iconSize,
        ),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: starWidgets,
    );
  }
}
