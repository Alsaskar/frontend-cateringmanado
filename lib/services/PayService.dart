import 'package:cateringmanado_new/helpers/AuthHelper.dart';

import '../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class PayService {
  Future<Map> payStepOne(String idItemMaster, String noInvoice, String uangMuka,
      File photo) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/pay/step-one');

    var mimeTypeData =
        lookupMimeType(photo.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final req = http.MultipartRequest('POST', urlApi)
      ..fields['idItemMaster'] = idItemMaster
      ..fields['noInvoice'] = noInvoice
      ..fields['jumlahUangMuka'] = uangMuka.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'photo',
        photo.path,
        filename: basename(photo.path),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ))
      ..headers['Authorization'] = 'Bearer $token';

    final res = await http.Response.fromStream(await req.send());
    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  Future<Map> payStepTwo(
      String idItemMaster, String uangTengah, File photo) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/pay/step-two/${idItemMaster}');

    var mimeTypeData =
        lookupMimeType(photo.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final req = http.MultipartRequest('PUT', urlApi)
      ..fields['jumlahUangTengah'] = uangTengah.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'photo',
        photo.path,
        filename: basename(photo.path),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ))
      ..headers['Authorization'] = 'Bearer $token';

    final res = await http.Response.fromStream(await req.send());
    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  Future<Map> payStepThree(
      String idItemMaster, String uangTengah, File photo) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/pay/step-three/${idItemMaster}');

    var mimeTypeData =
        lookupMimeType(photo.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final req = http.MultipartRequest('PUT', urlApi)
      ..fields['jumlahUangLunas'] = uangTengah.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'photo',
        photo.path,
        filename: basename(photo.path),
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ))
      ..headers['Authorization'] = 'Bearer $token';

    final res = await http.Response.fromStream(await req.send());
    jsonData = jsonDecode(res.body);

    return jsonData;
  }

  // cek status pembayaran
  Future<Map> cekStatus(String idItemMaster, String noInvoice) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse(
        '${Config.baseUrl}/pay/cek-status?idItemMaster=${idItemMaster}&noInvoice=${noInvoice}');

    try {
      final res = await http.get(
        urlApi,
        headers: <String, String>{
          'Authorization': 'Bearer ${token}',
        },
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        return {
          'stepOne': data['stepOne'],
          'stepTwo': data['stepTwo'],
          'stepThree': data['stepThree'],
          'result': data['result']
        };
      } else {
        return {
          'result': {},
        };
      }
    } catch (err) {
      print('Error Server : $err');
      rethrow; // Rethrow untuk mengirim kembali exception ke pemanggil
    }
  }

  Future<Map> fetchData(String idItemMaster) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/pay/${idItemMaster}');

    try {
      final res = await http.get(
        urlApi,
        headers: <String, String>{
          'Authorization': 'Bearer ${token}',
        },
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        return {
          'result': data['result'],
        };
      } else {
        return {
          'result': [],
        };
      }
    } catch (err) {
      print('Error Server : $err');
      rethrow; // Rethrow untuk mengirim kembali exception ke pemanggil
    }
  }
}
