import 'package:intl/intl.dart';

class Hooks {
  static String formatDateTime(String tanggal) {
    DateTime date = DateTime.parse(tanggal);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // tampilkan harga dalam bentuk Indonesia
  static String formatHargaId(int harga) {
    var data = NumberFormat.decimalPattern('id');
    return data.format(harga).toString();
  }

  static String capitalizeFirstLetter(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
