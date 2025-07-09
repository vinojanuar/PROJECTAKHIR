// To parse this JSON data, do
//
//     final register = registerFromJson(jsonString);

import 'dart:convert';

Register registerFromJson(String str) => Register.fromJson(json.decode(str));

String registerToJson(Register data) => json.encode(data.toJson());

class Register {
  String? message;
  Data? data;

  Register({this.message, this.data});

  factory Register.fromJson(Map<String, dynamic> json) => Register(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  String? token;
  User? user;
  String? profilePhotoUrl;

  Data({this.token, this.user, this.profilePhotoUrl});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    profilePhotoUrl: json["profile_photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
    "profile_photo_url": profilePhotoUrl,
  };
}

class User {
  String? name;
  String? email;
  int? batchId;
  int? trainingId;
  String? jenisKelamin;
  String? profilePhoto;
  String? updatedAt;
  String? createdAt;
  int? id;
  Batch? batch;
  Training? training;

  User({
    this.name,
    this.email,
    this.batchId,
    this.trainingId,
    this.jenisKelamin,
    this.profilePhoto,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.batch,
    this.training,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    batchId: int.tryParse(json["batch_id"].toString()),
    trainingId: int.tryParse(json["training_id"].toString()),
    jenisKelamin: json["jenis_kelamin"],
    profilePhoto: json["profile_photo"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
    batch: json["batch"] == null ? null : Batch.fromJson(json["batch"]),
    training: json["training"] == null
        ? null
        : Training.fromJson(json["training"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "batch_id": batchId,
    "training_id": trainingId,
    "jenis_kelamin": jenisKelamin,
    "profile_photo": profilePhoto,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
    "batch": batch?.toJson(),
    "training": training?.toJson(),
  };
}

class Batch {
  int? id;
  String? batchKe;
  DateTime? startDate;
  DateTime? endDate;
  String? createdAt;
  String? updatedAt;

  Batch({
    this.id,
    this.batchKe,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
    id: json["id"],
    batchKe: json["batch_ke"],
    startDate: json["start_date"] == null
        ? null
        : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_ke": batchKe,
    "start_date":
        "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Training {
  int? id;
  String? title;
  dynamic description;
  dynamic participantCount;
  dynamic standard;
  dynamic duration;
  String? createdAt;
  String? updatedAt;

  Training({
    this.id,
    this.title,
    this.description,
    this.participantCount,
    this.standard,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  factory Training.fromJson(Map<String, dynamic> json) => Training(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    participantCount: json["participant_count"],
    standard: json["standard"],
    duration: json["duration"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "participant_count": participantCount,
    "standard": standard,
    "duration": duration,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
