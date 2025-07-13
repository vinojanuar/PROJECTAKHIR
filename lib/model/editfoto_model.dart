// To parse this JSON data, do
//
//     final editFoto = editFotoFromJson(jsonString);

import 'dart:convert';

EditFoto editFotoFromJson(String str) => EditFoto.fromJson(json.decode(str));

String editFotoToJson(EditFoto data) => json.encode(data.toJson());

class EditFoto {
  String? message;
  Data? data;

  EditFoto({this.message, this.data});

  factory EditFoto.fromJson(Map<String, dynamic> json) => EditFoto(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  String? profilePhoto;

  Data({this.profilePhoto});

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(profilePhoto: json["profile_photo"]);

  Map<String, dynamic> toJson() => {"profile_photo": profilePhoto};
}
