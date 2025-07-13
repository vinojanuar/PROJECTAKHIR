import 'dart:convert';

Izin izinFromJson(String str) => Izin.fromJson(json.decode(str));
String izinToJson(Izin data) => json.encode(data.toJson());

class Izin {
  String? message;
  IzinData? data;

  Izin({this.message, this.data});

  factory Izin.fromJson(Map<String, dynamic> json) => Izin(
    message: json["message"],
    data: json["data"] == null ? null : IzinData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class IzinData {
  int? id;
  String? attendanceDate;
  dynamic checkInTime;
  dynamic checkInLat;
  dynamic checkInLng;
  dynamic checkInLocation;
  dynamic checkInAddress;
  String? status;
  String? alasanIzin;

  IzinData({
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

  factory IzinData.fromJson(Map<String, dynamic> json) => IzinData(
    id: json["id"],
    attendanceDate: json["attendance_date"],
    checkInTime: json["check_in_time"],
    checkInLat: json["check_in_lat"],
    checkInLng: json["check_in_lng"],
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date": attendanceDate,
    "check_in_time": checkInTime,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}
