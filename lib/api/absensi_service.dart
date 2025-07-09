import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projectakhir/model/checkin_model.dart';
import 'package:projectakhir/model/checkout_model.dart';

class AbsenApiService {
  static const String _baseUrl = 'https://appabsensi.mobileprojp.com/api/absen';

  // Fungsi untuk Check In
  static Future<AbsenCheckin?> checkIn({
    required int userId,
    required String checkInLocation,
    required String checkInAddress,
    required double checkInLat,
    required double checkInLng,
    required String status,
    String? alasanIzin,
  }) async {
    final url = Uri.parse('$_baseUrl/check-in');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // Tambahkan jika pakai token
        },
        body: jsonEncode({
          "user_id": userId,
          "check_in_location": checkInLocation,
          "check_in_address": checkInAddress,
          "check_in_lat": checkInLat,
          "check_in_lng": checkInLng,
          "status": status,
          "alasan_izin": alasanIzin,
        }),
      );

      if (response.statusCode == 200) {
        return absenCheckinFromJson(response.body);
      } else {
        print('Gagal Check-In: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error Check-In: $e');
      return null;
    }
  }

  // Fungsi untuk Check Out
  static Future<AbsenCheckout?> checkOut({
    required int userId,
    required String checkOutLocation,
    required String checkOutAddress,
    required double checkOutLat,
    required double checkOutLng,
    required String status,
    String? alasanIzin,
  }) async {
    final url = Uri.parse('$_baseUrl/check-out');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // Tambahkan jika pakai token
        },
        body: jsonEncode({
          "user_id": userId,
          "check_out_location": checkOutLocation,
          "check_out_address": checkOutAddress,
          "check_out_lat": checkOutLat,
          "check_out_lng": checkOutLng,
          "status": status,
          "alasan_izin": alasanIzin,
        }),
      );

      if (response.statusCode == 200) {
        return absenCheckoutFromJson(response.body);
      } else {
        print('Gagal Check-Out: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error Check-Out: $e');
      return null;
    }
  }
}
