import 'package:cateringmanado_new/screens/dashboard_catering.dart';
import 'package:cateringmanado_new/screens/dashboard_customer.dart';
import 'package:cateringmanado_new/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:cateringmanado_new/helpers/SessionHelper.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  void initState() {
    super.initState();

    SessionHelper.checkSesiLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.getDataLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.data!['loggedIn'] == false) {
          return Container();
        } else {
          Map<dynamic, dynamic>? user = snapshot.data;

          // jika customer yg login
          if (user!['role'] == 'customer') return DashboardCustomer();

          // jika catering yang login
          return DashboardCatering(
            idUser: user['id'],
            email: user['email'],
            fullname: "${user['firstname']} ${user['lastname']}",
          );
        }
      },
    );
  }
}
