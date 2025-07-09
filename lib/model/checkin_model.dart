// To parse this JSON data, do
//
//     final absenCheckin = absenCheckinFromJson(jsonString);

import 'dart:convert';

AbsenCheckin absenCheckinFromJson(String str) =>
    AbsenCheckin.fromJson(json.decode(str));

String absenCheckinToJson(AbsenCheckin data) => json.encode(data.toJson());

class AbsenCheckin {
  String message;
  Data data;

  AbsenCheckin({required this.message, required this.data});

  factory AbsenCheckin.fromJson(Map<String, dynamic> json) =>
      AbsenCheckin(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int userId;
  String checkIn;
  String checkInLocation;
  double checkInLat;
  double checkInLng;
  String checkInAddress;
  String status;
  dynamic alasanIzin;
  String updatedAt;
  String createdAt;
  int id;

  Data({
    required this.userId,
    required this.checkIn,
    required this.checkInLocation,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkInAddress,
    required this.status,
    required this.alasanIzin,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    checkIn: json["check_in"],
    checkInLocation: json["check_in_location"],
    checkInLat: json["check_in_lat"]?.toDouble(),
    checkInLng: json["check_in_lng"]?.toDouble(),
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "check_in": checkIn,
    "check_in_location": checkInLocation,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
  };
}
