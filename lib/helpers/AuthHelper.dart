import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static const String _isLoggedIn = 'isLoggedIn';

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedIn) ?? false;
  }

  static Future<void> LogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedIn, true);
  }

  static Future<void> LogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool(_isLoggedIn, false);
    await prefs.remove('isLoggedIn');
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await prefs.getString('token');

    return token;
  }

  static Future<void> saveUserId(String idUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', idUser);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await prefs.getString('userId');

    return userId!;
  }
}
