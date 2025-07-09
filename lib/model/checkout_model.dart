// To parse this JSON data, do
//
//     final absenCheckout = absenCheckoutFromJson(jsonString);

import 'dart:convert';

AbsenCheckout absenCheckoutFromJson(String str) =>
    AbsenCheckout.fromJson(json.decode(str));

String absenCheckoutToJson(AbsenCheckout data) => json.encode(data.toJson());

class AbsenCheckout {
  String? message;
  Data? data;

  AbsenCheckout({this.message, this.data});

  factory AbsenCheckout.fromJson(Map<String, dynamic> json) => AbsenCheckout(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  int? userId;
  String? checkIn;
  String? checkInLocation;
  String? checkInAddress;
  String? checkOut;
  String? checkOutLocation;
  String? checkOutAddress;
  String? status;
  dynamic alasanIzin;
  String? createdAt;
  String? updatedAt;
  double? checkInLat;
  double? checkInLng;
  double? checkOutLat;
  double? checkOutLng;

  Data({
    this.id,
    this.userId,
    this.checkIn,
    this.checkInLocation,
    this.checkInAddress,
    this.checkOut,
    this.checkOutLocation,
    this.checkOutAddress,
    this.status,
    this.alasanIzin,
    this.createdAt,
    this.updatedAt,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    checkIn: json["check_in"],
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    checkOut: json["check_out"],
    checkOutLocation: json["check_out_location"],
    checkOutAddress: json["check_out_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    checkInLat: json["check_in_lat"]?.toDouble(),
    checkInLng: json["check_in_lng"]?.toDouble(),
    checkOutLat: json["check_out_lat"]?.toDouble(),
    checkOutLng: json["check_out_lng"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "check_in": checkIn,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "check_out": checkOut,
    "check_out_location": checkOutLocation,
    "check_out_address": checkOutAddress,
    "status": status,
    "alasan_izin": alasanIzin,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_out_lat": checkOutLat,
    "check_out_lng": checkOutLng,
  };
}
