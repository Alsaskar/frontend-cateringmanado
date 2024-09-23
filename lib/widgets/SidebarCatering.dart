import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/screens/food/list_food.dart';
import 'package:cateringmanado_new/screens/login.dart';
import 'package:cateringmanado_new/screens/main_dashboard.dart';
import 'package:cateringmanado_new/screens/order/list_by_toko.dart';
import 'package:cateringmanado_new/screens/profil_catering.dart';
import 'package:cateringmanado_new/widgets/AlertConfirm.dart';
import 'package:flutter/material.dart';

class SidebarCatering extends StatelessWidget {
  final String fullname;
  final String email;
  final String idUser;

  const SidebarCatering(
      {required this.fullname, required this.email, required this.idUser});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Bagian foto profil di atas
          UserAccountsDrawerHeader(
            accountName: Text('${this.fullname}'),
            accountEmail: Text('${this.email}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/img/shop_food.png'), // Ganti dengan gambar profil
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          // Menu di bawahnya
          _buildDrawerItem(
            icon: Icons.dashboard,
            text: 'Dashboard',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainDashboard(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.food_bank,
            text: 'Data Makanan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListFood(
                    idUser: this.idUser,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart,
            text: 'Pesanan Customer',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListOrderByToko(
                    idUser: this.idUser,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.people,
            text: 'Profil',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilCatering(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Keluar',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertConfirm(
                    title: 'Konfirmasi',
                    message: 'Yakin ingin keluar?',
                    clickKanan: () {
                      AuthHelper.LogOut();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    clickKiri: () {
                      Navigator.of(context).pop();
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
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membuat item menu
  Widget _buildDrawerItem({
    IconData? icon,
    String? text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text!),
      onTap: onTap,
    );
  }
}
