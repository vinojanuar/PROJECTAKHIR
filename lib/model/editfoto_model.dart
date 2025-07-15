// To parse this JSON data, do
//
//     final editFoto = editFotoFromJson(jsonString);

import 'dart:convert';

EditFoto editFotoFromJson(String str) => EditFoto.fromJson(json.decode(str));

String editFotoToJson(EditFoto data) => json.encode(data.toJson());

class EditFoto {
  String? message;
  FotoData? data;

  EditFoto({this.message, this.data});

  factory EditFoto.fromJson(Map<String, dynamic> json) => EditFoto(
    message: json["message"],
    data: json["data"] == null ? null : FotoData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class FotoData {
  String? profilePhoto;

  FotoData({this.profilePhoto});

  factory FotoData.fromJson(Map<String, dynamic> json) =>
      FotoData(profilePhoto: json["profile_photo"]);

  Map<String, dynamic> toJson() => {"profile_photo": profilePhoto};
}
