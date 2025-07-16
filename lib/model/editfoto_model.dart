// To parse this JSON data, do
//
//     final editFoto = editFotoFromJson(jsonString);

import 'dart:convert';

EditFoto editFotoFromJson(String str) => EditFoto.fromJson(json.decode(str));

String editFotoToJson(EditFoto data) => json.encode(data.toJson());

// Model utama untuk response edit foto profil.
class EditFoto {
  String? message;
  FotoData? data;

  // Konstruktor EditFoto
  EditFoto({this.message, this.data});

  // Membuat objek EditFoto dari JSON
  factory EditFoto.fromJson(Map<String, dynamic> json) => EditFoto(
    message: json["message"],
    data: json["data"] == null ? null : FotoData.fromJson(json["data"]),
  );

  // Mengubah objek EditFoto ke bentuk JSON
  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

// Model data untuk data foto profil.
class FotoData {
  String? profilePhoto;

  // Konstruktor FotoData
  FotoData({this.profilePhoto});

  // Membuat objek FotoData dari JSON
  factory FotoData.fromJson(Map<String, dynamic> json) =>
      FotoData(profilePhoto: json["profile_photo"]);

  // Mengubah objek FotoData ke bentuk JSON
  Map<String, dynamic> toJson() => {"profile_photo": profilePhoto};
}
