import 'dart:math';

class InvoiceGenerator {
  // Fungsi untuk mendapatkan tanggal saat ini dalam format string
  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }

  // Fungsi untuk menghasilkan ID unik acak dengan panjang tertentu
  String _generateUniqueId({int length = 3}) {
    final Random random = Random();
    final int max = pow(10, length) as int;
    final int uniqueId = random.nextInt(max);
    return uniqueId.toString().padLeft(length, '0');
  }

  // Fungsi untuk menghasilkan nomor invoice dalam format yang diinginkan
  String generateInvoiceNumber() {
    final String currentDate = _getCurrentDate();
    final String uniqueId = _generateUniqueId();

    return '$currentDate-$uniqueId';
  }
}
