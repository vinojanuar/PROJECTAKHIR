import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projectakhir/endpoint/endpoint.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/model/absenstatus_model.dart';
import 'package:projectakhir/model/absentoday_model.dart';
import 'package:projectakhir/model/checkin_model.dart';
import 'package:projectakhir/model/historyabsen_model.dart';
import 'package:projectakhir/model/izin_model.dart';

class AbsenApiService {
  // === CHECK IN ===
  static Future<CheckIn?> checkIn({
    required String attendanceDate,
    required String checkInTime,
    required double checkInLat,
    required double checkInLng,
    required String checkInAddress,
    required String status,
    String? alasanIzin,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse('${Endpoint.baseUrl}/api/absen/check-in'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
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

  // === CHECK OUT ===
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

    return response.statusCode == 200;
  }

  // === HISTORY ABSEN ===
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

  // === ABSEN STATUS ===
  static Future<AbsenStatus?> fetchAbsenStatus() async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse("${Endpoint.baseUrlApi}/absen/stats");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return absenStatusFromJson(response.body);
    } else {
      throw Exception("Gagal memuat status absen: ${response.statusCode}");
    }
  }

  // === ABSEN TODAY ===
  static Future<AbsenToday?> fetchAbsenToday() async {
    final token = await PreferenceHandler.getToken();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final url = Uri.parse(
      "${Endpoint.baseUrlApi}/absen/today?attendance_date=$today",
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return absenTodayFromJson(response.body);
    } else {
      throw Exception("Gagal memuat absen hari ini");
    }
  }

  // === POST IZIN ===
  static Future<Izin?> postIzin({
    required String date,
    required String alasanIzin,
  }) async {
    final token = await PreferenceHandler.getToken();
    final url = Uri.parse("https://appabsensi.mobileprojp.com/api/izin");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"date": date, "alasan_izin": alasanIzin}),
    );

    if (response.statusCode == 200) {
      return izinFromJson(response.body);
    } else {
      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");
      throw Exception("Gagal mengirim data izin");
    }
  }

  // === FETCH IZIN (GET IZIN TODAY) ===
  static Future<Izin?> fetchIzinHariIni() async {
    final token = await PreferenceHandler.getToken();

    final url = Uri.parse("${Endpoint.baseUrlApi}/absen/izin");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return izinFromJson(response.body);
    } else {
      throw Exception("Gagal memuat data izin hari ini");
    }
  }
}
