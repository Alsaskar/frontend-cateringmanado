import 'dart:convert';
import 'dart:io';
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import '../config.dart';
import 'package:mime/mime.dart';

class AuthService {
  Future<Map> signIn(String noHp, String password) async {
    Map data = {'noHp': noHp, 'password': password};
    var jsonData = null;
    Uri urlApi = Uri.parse('${Config.baseUrl}/auth/login');

    var res = await http.post(urlApi, body: data);
    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  // register customer
  Future<Map> regisCustomer(String firstname, String lastname, String noHp,
      String email, String password, String c_pass) async {
    Map data = {
      'firstname': firstname,
      'lastname': lastname,
      'noHp': noHp,
      'email': email,
      'password': password,
      'c_pass': c_pass,
      'role': 'customer'
    };
    var jsonData = null;

    Uri urlApi = Uri.parse('${Config.baseUrl}/auth/regis-customer');

    var res = await http.post(urlApi, body: data);
    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  // register customer
  Future<Map> regisCatering(
    String firstname,
    String lastname,
    String nik,
    File photo,
    String noHp,
    String email,
    String fullname,
    String alamat,
    String password,
    String c_pass,
  ) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/auth/regis-catering');

    var mimeTypeData =
        lookupMimeType(photo.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final req = http.MultipartRequest('POST', urlApi)
      ..fields['firstname'] = firstname
      ..fields['lastname'] = lastname
      ..fields['nik'] = nik
      ..fields['noHp'] = noHp
      ..fields['email'] = email
      ..fields['fullname'] = fullname
      ..fields['alamat'] = alamat
      ..fields['password'] = password
      ..fields['c_pass'] = c_pass
      ..files.add(await http.MultipartFile.fromPath(
        'fotoKtp',
        photo.path,
        filename: basename(photo.path),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ))
      ..headers['Authorization'] = 'Bearer $token';

    final res = await http.Response.fromStream(await req.send());
    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  static Future<Map> getDataLoggedIn() async {
    String? token = await AuthHelper.getToken();

    Uri urlApi = Uri.parse('${Config.baseUrl}/auth');
    var res = await http.get(urlApi, headers: <String, String>{
      'Authorization': 'Bearer ${token}',
    });

    return jsonDecode(res.body);
  }
}
