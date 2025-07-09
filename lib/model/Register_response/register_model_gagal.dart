// To parse this JSON data, do
//
//     final registerGagal = registerGagalFromJson(jsonString);

import 'dart:convert';

RegisterGagal registerGagalFromJson(String str) =>
    RegisterGagal.fromJson(json.decode(str));

String registerGagalToJson(RegisterGagal data) => json.encode(data.toJson());

class RegisterGagal {
  String? message;
  Errors? errors;

  RegisterGagal({this.message, this.errors});

  factory RegisterGagal.fromJson(Map<String, dynamic> json) => RegisterGagal(
    message: json["message"],
    errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "errors": errors?.toJson(),
  };
}

class Errors {
  List<String>? email;

  Errors({this.email});

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
    email: json["email"] == null
        ? []
        : List<String>.from(json["email"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
  };
}
