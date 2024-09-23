import 'package:cateringmanado_new/helpers/AuthHelper.dart';

import '../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  Future<Map> changePass(Map<String, dynamic> data, String idUser) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/user/change-pass/${idUser}');

    var res = await http.put(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  Future<Map> createToko(Map<String, dynamic> data) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/user/create-toko');

    var res = await http.post(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  static Future<Map> getProfilToko(String idUser) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();

    Uri urlApi = Uri.parse('${Config.baseUrl}/user/profiltoko/${idUser}');
    var res = await http.get(urlApi, headers: <String, String>{
      'Authorization': 'Bearer ${token}',
    });

    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  Future<Map> changeInformasi(Map<dynamic, dynamic> dataInfo) async {
    print(dataInfo);
    Map data = {
      'firstname': dataInfo['firstname'],
      'lastname': dataInfo['lastname'],
      'fullname': dataInfo['fullname'],
      'alamat': dataInfo['alamat'],
      'namaRekening': dataInfo['namaRekening'],
      'noRekening': dataInfo['noRekening'],
      'namaBank': dataInfo['namaBank'],
    };
    var jsonData = null;
    String? token = await AuthHelper.getToken();

    Uri urlApi =
        Uri.parse('${Config.baseUrl}/user/change-info/${dataInfo['idUser']}');

    var res = await http.put(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    jsonData = jsonDecode(res.body);

    return jsonData;
  }
}
