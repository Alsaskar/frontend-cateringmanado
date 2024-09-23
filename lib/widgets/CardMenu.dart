import 'package:flutter/material.dart';

class CardMenu extends StatelessWidget {
  final String foto;
  final String namaMenu;
  final String harga;
  final String namaToko;

  const CardMenu({
    required this.foto,
    required this.namaMenu,
    required this.harga,
    required this.namaToko,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 5,
        left: 5,
        right: 5,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Color(0xff3b3b3b),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              foto,
              width: double.infinity,
              height: 100,
            ),
          ),
          SizedBox(height: 10),
          Text(
            namaMenu,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Text(
                harga,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.star_border,
                size: 15,
                color: Colors.white,
              ),
              Icon(
                Icons.star,
                size: 15,
                color: Color(0xffedc446),
              ),
              Icon(
                Icons.star,
                size: 15,
                color: Color(0xffedc446),
              ),
              Icon(
                Icons.star,
                size: 15,
                color: Color(0xffedc446),
              ),
              Icon(
                Icons.star,
                size: 15,
                color: Color(0xffedc446),
              ),
            ],
          ),
          Divider(color: Colors.white),
          Text(
            namaToko,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
