// To parse this JSON data, do
//
//     final checkIn = checkInFromJson(jsonString);

import 'dart:convert';

CheckIn checkInFromJson(String str) => CheckIn.fromJson(json.decode(str));

String checkInToJson(CheckIn data) => json.encode(data.toJson());

class CheckIn {
  String? message;
  Data? data;

  CheckIn({this.message, this.data});

  factory CheckIn.fromJson(Map<String, dynamic> json) => CheckIn(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  DateTime? attendanceDate;
  String? checkInTime;
  double? checkInLat;
  double? checkInLng;
  String? checkInLocation;
  String? checkInAddress;
  String? status;
  dynamic alasanIzin;

  Data({
    this.id,
    this.attendanceDate,
    this.checkInTime,
    this.checkInLat,
    this.checkInLng,
    this.checkInLocation,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    attendanceDate: json["attendance_date"] == null
        ? null
        : DateTime.parse(json["attendance_date"]),
    checkInTime: json["check_in_time"],
    checkInLat: json["check_in_lat"]?.toDouble(),
    checkInLng: json["check_in_lng"]?.toDouble(),
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date":
        "${attendanceDate!.year.toString().padLeft(4, '0')}-${attendanceDate!.month.toString().padLeft(2, '0')}-${attendanceDate!.day.toString().padLeft(2, '0')}",
    "check_in_time": checkInTime,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}
