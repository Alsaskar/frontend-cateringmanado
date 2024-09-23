import 'package:cateringmanado_new/helpers/InvoiceGenerator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHelper {
  Future<void> setNoInvoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'noInvoice',
      InvoiceGenerator().generateInvoiceNumber(),
    );
  }

  Future<String> getNoInvoice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String noInvoice = prefs.getString('noInvoice') ?? '';

    return noInvoice;
  }

  Future<void> setStatusMaster() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'noInvoice',
      InvoiceGenerator().generateInvoiceNumber(),
    );
  }

  Future<String> getStatusMaster() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String statusMaster = prefs.getString('statusMasterOrder') ?? '';

    return statusMaster;
  }
}
