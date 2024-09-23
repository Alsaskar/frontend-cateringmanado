import 'dart:convert';

import 'package:cateringmanado_new/config.dart';
import 'package:cateringmanado_new/helpers/AuthHelper.dart';
import 'package:http/http.dart' as http;

class OrderService {
  Future<Map> add(Map<dynamic, dynamic> data) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order');

    final res = await http.post(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map> detailMaster(String noInvoice, String idUser) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse(
      '${Config.baseUrl}/order/master/detail/${noInvoice}?idUser=${idUser}',
    );

    final res = await http.get(urlApi, headers: <String, String>{
      'Authorization': 'Bearer ${token}',
    });

    return jsonDecode(res.body);
  }

  Future<Map> cancel(String noInvoice, Map<dynamic, dynamic> data) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/cancel/${noInvoice}');

    final res = await http.put(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map> deleteItem(Map<dynamic, dynamic> data) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/delete-item');

    final res = await http.delete(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map> cekStatusMaster(String idUser) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse(
      '${Config.baseUrl}/order/master/cek-status/${idUser}',
    );

    final res = await http.get(
      urlApi,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map> confirmOrder(String noInvoice, Map<dynamic, dynamic> data) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/confirm/${noInvoice}');

    final res = await http.put(
      urlApi,
      body: data,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  // ambil data untuk di tampilkan pada screen cart
  Future<Map> fetchCart(String idUser) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/cart/${idUser}');

    final res = await http.get(
      urlApi,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map> fetchDetailCart(String noInvoice) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/view-cart/${noInvoice}');

    try {
      final res = await http.get(
        urlApi,
        headers: <String, String>{
          'Authorization': 'Bearer ${token}',
        },
      );

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

  Future<Map<String, dynamic>> listOrderCustomer(
      String? idAdminToko, String search, int page, int limit) async {
    Uri urlApi = Uri.parse(
        '${Config.baseUrl}/order/list-pesanan/${idAdminToko}?search=${search}&page=${page}&limit=${limit}');
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

  Future<Map<String, dynamic>> updateStatusCekNotif(
      String id, String status) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/status-cek-notif/${id}');
    String? token = await AuthHelper.getToken();

    final res = await http.put(
      urlApi,
      body: {'status': status},
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> listItemCustomer(String idItemMaster) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/item/${idItemMaster}');
    String? token = await AuthHelper.getToken();

    try {
      final res = await http.get(
        urlApi,
        headers: <String, String>{
          'Authorization': 'Bearer ${token}',
        },
      );

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

  // update status order
  // Memasak, Packing, dll
  Future<Map<String, dynamic>> updateStatus(
      String id, String noInvoice, String status) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/update-status/${id}');
    String? token = await AuthHelper.getToken();

    final res = await http.put(
      urlApi,
      body: {
        'statusProses': status,
        'noInvoice': noInvoice,
      },
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> listHistory(String? idUser) async {
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/list-history/${idUser}');
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

  Future<Map> deleteData(String noInvoice) async {
    String? token = await AuthHelper.getToken();
    Uri urlApi = Uri.parse('${Config.baseUrl}/order/${noInvoice}');

    final res = await http.delete(
      urlApi,
      headers: <String, String>{
        'Authorization': 'Bearer ${token}',
      },
    );

    return jsonDecode(res.body);
  }

  Future<int> total(String idAdminToko) async {
    Uri urlApi =
        Uri.parse('${Config.baseUrl}/order/total?idAdminToko=${idAdminToko}');

    final res = await http.get(urlApi);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      return data['result'];
    } else {
      return 0;
    }
  }
}
