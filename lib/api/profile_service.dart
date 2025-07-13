import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projectakhir/model/editfoto_model.dart';
import 'package:projectakhir/model/editprofile_model.dart';
import 'package:projectakhir/model/profile_model.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/endpoint/endpoint.dart';

class ProfileApiService {
  static Future<Profile?> fetchProfile() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse('${Endpoint.baseUrl}/api/profile'), // Ganti sesuai API kamu
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<EditProfile> editProfile({
    required String name,
    required String email,
    required String jenisKelamin,
    required String batchId,
    required String trainingId,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.put(
      Uri.parse(Endpoint.editProfile),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'jenis_kelamin': jenisKelamin,
        'batch_id': batchId,
        'training_id': trainingId,
      }),
    );

    if (response.statusCode == 200) {
      return editProfileFromJson(response.body);
    } else {
      throw Exception('Gagal memperbarui profil: ${response.body}');
    }
  }

  static Future<EditFoto> uploadProfilePhoto(File file) async {
    final token = await PreferenceHandler.getToken();
    final uri = Uri.parse(
      'https://appabsensi.mobileprojp.com/api/profile/photo',
    );

    final request = http.MultipartRequest('POST', uri)
      ..headers['Accept'] = 'application/json'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        await http.MultipartFile.fromPath('profile_photo', file.path),
      );

    final response = await request.send();
    final resStr = await response.stream.bytesToString(); // Tangkap isi respons

    if (response.statusCode == 200) {
      return editFotoFromJson(resStr); // Sesuai model
    } else {
      // Tambahkan debug log atau lempar pesan lebih informatif
      print("Gagal upload foto profil - status: ${response.statusCode}");
      print("Isi respons: $resStr");

      throw Exception("Gagal upload foto profil: $resStr");
    }
  }
}
