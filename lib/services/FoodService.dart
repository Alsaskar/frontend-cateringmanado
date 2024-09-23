import 'package:path/path.dart';
import 'dart:io';
import '../config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class FoodService {
  Future<Map> add(String idAdminToko, String nama, int harga, String deskripsi,
      File photo) async {
    var jsonData = null;
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/food');

    var mimeTypeData =
        lookupMimeType(photo.path, headerBytes: [0xFF, 0xD8])?.split('/');

    final req = http.MultipartRequest('POST', urlApi)
      ..fields['idAdminToko'] = idAdminToko
      ..fields['nama'] = nama
      ..fields['harga'] = harga.toString()
      ..fields['deskripsi'] = deskripsi
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

  // ambil makanan berdasarkan toko
  Future<Map<String, dynamic>> listDataByToko(
      String idAdminToko, String search, int page, int limit) async {
    Uri urlApi = Uri.parse(
        '${Config.baseUrl}/food/by-toko/${idAdminToko}?search=${search}&page=${page}&limit=${limit}');
    String? token = await AuthHelper.getToken();

    try {
      final res = await http.get(urlApi, headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      });

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        // set list jika hasilnya null
        data['result'] = data['result'] ?? [];

        return {
          'result': data['result'],
          'limit': data['limit'],
          'totalRows': data['totalRows'],
          'totalPage': data['totalPage']
        };
      } else {
        return {
          'result': [],
          'totalPages': 1,
        };
      }
    } catch (err) {
      print("Error Server : ${err}");
      rethrow;
    }
  }

  // tampil semua makanan
  Future<Map<String, dynamic>> listOrder(
      String? idAdminToko, String search, int page, int limit) async {
    Uri urlApi = Uri.parse(
        '${Config.baseUrl}/food/list-order?idAdminToko=${idAdminToko}&search=${search}&page=${page}&limit=${limit}');
    String? token = await AuthHelper.getToken();

    try {
      final res = await http.get(urlApi, headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      });

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        // set list jika hasilnya null
        data['result'] = data['result'] ?? [];

        return {
          'result': data['result'],
          'limit': data['limit'],
          'totalRows': data['totalRows'],
          'totalPage': data['totalPage']
        };
      } else {
        return {
          'result': [],
          'totalPage': 1,
        };
      }
    } catch (err) {
      print('Error Server : $err');
      rethrow; // Rethrow untuk mengirim kembali exception ke pemanggil
    }
  }

  Future<Map<String, dynamic>> menuTerbaik(int limit) async {
    Uri urlApi =
        Uri.parse('${Config.baseUrl}/food/menu-terbaik?limit=${limit}');

    try {
      final res = await http.get(urlApi);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        // set list jika hasilnya null
        data['result'] = data['result'] ?? [];

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

  Future<Map> updateData(String id, Map<dynamic, dynamic> data) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/food/${id}');

    final res = await http.put(urlApi, body: data, headers: <String, String>{
      'Authorization': 'Bearer ${token}',
    });

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> deleteData(String id) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/food/${id}');
    String? token = await AuthHelper.getToken();

    final res = await http.delete(urlApi, headers: <String, String>{
      'Authorization': 'Bearer ${token}',
    });

    return jsonDecode(res.body);
  }

  Future<Map> addRating(String idUser, String idMakanan, double score) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/food/rating');
    String? token = await AuthHelper.getToken();

    final res = await http.post(
      urlApi,
      body: {
        'userId': idUser,
        'makananId': idMakanan,
        'score': score.toString(),
      },
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<int> total(String idAdminToko) async {
    Uri urlApi =
        Uri.parse('${Config.baseUrl}/food/total?idAdminToko=${idAdminToko}');

    final res = await http.get(urlApi);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      return data['result'];
    } else {
      return 0;
    }
  }
}
