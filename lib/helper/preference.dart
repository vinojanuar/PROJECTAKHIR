import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _tokenKey = 'token';
  static const String _loginKey = 'login';

  /// Simpan token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Ambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Simpan status login
  static Future<void> saveLogin(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, isLoggedIn);
  }

  /// Ambil status login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  /// ✅ Simpan Check In Time per user
  static Future<void> saveCheckInTimeForUser(int userId, String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('check_in_time_user_$userId', time);
  }

  /// ✅ Ambil Check In Time per user
  static Future<String?> getCheckInTimeForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('check_in_time_user_$userId');
  }

  /// ✅ Simpan Check Out Time per user
  static Future<void> saveCheckOutTimeForUser(int userId, String time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('check_out_time_user_$userId', time);
  }

  /// ✅ Ambil Check Out Time per user
  static Future<String?> getCheckOutTimeForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('check_out_time_user_$userId');
  }

  /// Hapus semua data Check In & Out (kalau diperlukan)
  static Future<void> clearCheckTimesForUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('check_in_time_user_$userId');
    await prefs.remove('check_out_time_user_$userId');
  }

  /// Logout (hapus token & status login saja, data check in/out tetap aman)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_loginKey);
  }
}
