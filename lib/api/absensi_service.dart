import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projectakhir/endpoint/endpoint.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/model/checkin_model.dart';
import 'package:projectakhir/model/historyabsen_model.dart';

class AbsenApiService {
  static Future<CheckIn?> checkIn({
    required int userId,
    required String attendanceDate,
    required String checkInTime,
    required String checkInLocation,
    required String checkInAddress,
    required double checkInLat,
    required double checkInLng,
    required String status,
    String? alasanIzin,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse('${Endpoint.baseUrl}/api/absen/check-in'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'attendance_date': attendanceDate,
        'check_in': checkInTime,
        'check_in_lat': checkInLat,
        'check_in_lng': checkInLng,
        'check_in_address': checkInAddress,
        'status': status,
        'alasan_izin': alasanIzin,
      }),
    );

    if (response.statusCode == 200) {
      return CheckIn.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<bool> checkOut({
    required String attendanceDate,
    required String checkOutTime,
    required double checkOutLat,
    required double checkOutLng,
    required String checkOutAddress,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse('${Endpoint.baseUrl}/api/absen/check-out'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'attendance_date': attendanceDate,
        'check_out': checkOutTime,
        'check_out_lat': checkOutLat,
        'check_out_lng': checkOutLng,
        'check_out_address': checkOutAddress,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // History Absen
  static Future<List<Datum>?> fetchHistoryAbsen() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse('${Endpoint.baseUrl}/api/absen/history'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final historyAbsen = historyAbsenFromJson(response.body);
      return historyAbsen.data;
    } else {
      return null;
    }
  }
}
