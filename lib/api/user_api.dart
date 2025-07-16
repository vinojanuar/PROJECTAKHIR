import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projectakhir/endpoint/endpoint.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/model/Register_response/register_model_berhasil.dart';
import 'package:projectakhir/model/Register_response/register_model_gagal.dart';
import 'package:projectakhir/model/batch_model.dart';
import 'package:projectakhir/model/training_model.dart';

class UserService {
  /// Fungsi untuk registrasi user baru ke API.
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required int batchId,
    required int trainingId,
    required String jenisKelamin,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {
        "name": name,
        "email": email,
        "password": password,
        "batch_id": batchId.toString(),
        "training_id": trainingId.toString(),
        "jenis_kelamin": jenisKelamin,
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return registerFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerGagalFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  /// Fungsi untuk login user ke API dan menyimpan token jika berhasil.
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json", // WAJIB
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final registerData = registerFromJson(response.body);
      if (registerData.data?.token != null) {
        await PreferenceHandler.saveToken(registerData.data!.token!);
        await PreferenceHandler.saveLogin(true);
      }
      return registerData.toJson();
    } else if (response.statusCode == 422) {
      return registerGagalFromJson(response.body).toJson();
    } else {
      throw Exception("Failed to login user: ${response.statusCode}");
    }
  }

  /// Fungsi untuk mengambil daftar batch dari API.
  Future<Map<String, dynamic>> getListBatch() async {
    final response = await http.get(
      Uri.parse(Endpoint.batch),
      headers: {"Accept": "application/json"},
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return listBatchFromJson(response.body).toJson();
    } else {
      print("Failed to fetch batch list: ${response.statusCode}");
      throw Exception("Failed to fetch batch list: ${response.statusCode}");
    }
  }

  /// Fungsi untuk mengambil daftar training dari API.
  Future<Map<String, dynamic>> getListTraining() async {
    final response = await http.get(
      Uri.parse(Endpoint.training),
      headers: {"Accept": "application/json"},
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return listTrainingFromJson(response.body).toJson();
    } else {
      print("Failed to fetch training list: ${response.statusCode}");
      throw Exception("Failed to fetch training list: ${response.statusCode}");
    }
  }
}
