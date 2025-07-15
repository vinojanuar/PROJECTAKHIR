import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:projectakhir/endpoint/endpoint.dart';
import 'package:projectakhir/helper/preference.dart';
import 'package:projectakhir/model/editfoto_model.dart';
import 'package:projectakhir/model/editprofile_model.dart';
import 'package:projectakhir/model/profile_model.dart';

class ProfileApiService {
  static Future<Profile> getProfile() async {
    String? token = await PreferenceHandler.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);

    if (response.statusCode == 200) {
      print(profileFromJson(response.body));
      return profileFromJson(response.body);
    } else {
      print('${response.statusCode}');
      throw Exception("${response.statusCode}");
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
      Uri.parse(Endpoint.profile),
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

  static Future<EditFoto> uploadProfilePhoto({
    required String token,
    required File photoFile,
  }) async {
    final url = Uri.parse(Endpoint.addPhoto);
    final bytes = await photoFile.readAsBytes();
    final base64Image = base64Encode(bytes);
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'profile_photo': base64Image}),
    );
    print('Upload photo status: \\${response.statusCode}');
    print('Upload photo body: \\${response.body}');
    if (response.statusCode == 200) {
      return editFotoFromJson(response.body);
    } else {
      throw Exception('Failed to upload profile photo: ${response.body}');
    }
  }
}
