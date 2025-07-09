// To parse this JSON data, do
//
//     final loginGagal = loginGagalFromJson(jsonString);

import 'dart:convert';

LoginGagal loginGagalFromJson(String str) =>
    LoginGagal.fromJson(json.decode(str));

String loginGagalToJson(LoginGagal data) => json.encode(data.toJson());

class LoginGagal {
  String? message;
  Errors? errors;

  LoginGagal({this.message, this.errors});

  factory LoginGagal.fromJson(Map<String, dynamic> json) => LoginGagal(
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
