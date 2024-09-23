import 'package:cateringmanado_new/screens/home_menu.dart';
import 'package:cateringmanado_new/screens/login.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(180),
                  ),
                  color: Color(0xff6385FF),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Image.asset(
                    "assets/img/chef.png",
                    height: 300,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 370),
                  child: Container(
                    height: 100,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff000000).withOpacity(0.15),
                          offset: Offset(0, 0),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "CateringManado",
                            style: TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "Services",
                            style: TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 100),
                child: Image.asset(
                  "assets/img/rice.png",
                  height: 100,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 230, top: 40),
                child: Image.asset(
                  "assets/img/tomato.png",
                  height: 80,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 260, top: 130),
                child: Image.asset(
                  "assets/img/cabbage.png",
                  height: 80,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
            ),
            child: Text(
              "Sekarang Pesan Catering bisa dari Aplikasi!",
              style: TextStyle(
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Color(0xff6385FF),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff000000).withOpacity(0.15),
                        offset: Offset(0, 0),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: Text(
                      "Masuk",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 10, 189, 7),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeMenu(),
                        ),
                      );
                    },
                    child: Text(
                      "Menu",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
