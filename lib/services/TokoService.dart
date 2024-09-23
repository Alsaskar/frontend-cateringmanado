import '../config.dart';
import 'package:http/http.dart' as http;
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'dart:convert';

class TokoService {
  Future<Map<String, dynamic>> listToko(String alamat) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/catering?alamat=${alamat}');
    String? token = await AuthHelper.getToken();

    try {
      final res = await http.get(urlApi, headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      });

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        // set list jika hasilnya null
        data['result'] = data['result'] ?? [];

        return {'result': data['result']};
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
