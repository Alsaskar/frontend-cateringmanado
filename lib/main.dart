// ignore_for_file: prefer_const_constructors
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:cateringmanado_new/screens/homepage.dart';
import 'package:cateringmanado_new/screens/main_dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CateringManado',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: AuthHelper.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return MainDashboard();
            } else {
              return Homepage();
            }
          }
        },
      ),
    );
  }
}
